#include "stdio.h"
#include "mex.h"
#include "math.h"
#include "time.h"
#include "Definitions.h"
#include "Castan.h"
#include "Deriche.h"

#define MESSAGE_D_ERREUR "L'appel de la fonction se fait sous la forme : \n[ GradientX, GradientY, GradientXY ] = DeriveImage(ImageSource, alpha, type) \n type = 1 : shen-castan \n type = 2 : deriche"

void mexFunction(int nlhs, mxArray *plhs[],int nrhs, const mxArray *prhs[])
{
 double *Image, *Derive_x, *Derive_y, *Derive_xy, *pt, *ptd ;
 int TailleImage, Nlin, Ncol, lin, col ;
 double alpha ;
 unsigned char type_de_filtre ;
 int n ;

 switch(nlhs)
 {
  case 3 : break ;
  default : mexErrMsgTxt(MESSAGE_D_ERREUR) ; return ; break ;
 }

 switch(nrhs)
 {
  case 3 : break ;
  default : mexErrMsgTxt(MESSAGE_D_ERREUR) ; return ; break ;
 }

 Nlin = mxGetM(prhs[0]) ;
 Ncol = mxGetN(prhs[0]) ;

 if( ( mxGetM(prhs[1]) != 1 ) || ( mxGetN(prhs[1]) != 1 ) )
 {
  printf("un seul parametre pour les filtres\n") ;
  mexErrMsgTxt(MESSAGE_D_ERREUR) ; return ;
 }

 if( ( mxGetM(prhs[2]) != 1 ) || ( mxGetN(prhs[2]) != 1 ) )
 {
  printf("type = 1 (shen) ou 2 (deriche) " ) ;
  mexErrMsgTxt(MESSAGE_D_ERREUR) ; return ;
 }


 pt = mxGetPr(prhs[1]) ; alpha = (*pt) ;
 pt = mxGetPr(prhs[2]) ; type_de_filtre = (unsigned char)(*pt) ;

 TailleImage = Nlin * Ncol ;

 // Allocation de l'image

 Image = (double *)mxCalloc(TailleImage,sizeof(double)) ;
 if(Image==NULL)
 {
  printf("Probleme d'allocation pour %d bytes pour l'image source\n",TailleImage) ;
  mexErrMsgTxt("Pas assez de m�moire pour traiter de ce probl�me\n") ;
  return ;
 }

 Derive_x = (double *)mxCalloc(TailleImage,sizeof(double)) ;
 if(Derive_x==NULL)
 {
  mxFree(Image) ;
  printf("Probleme d'allocation pour %d bytes pour l'image cible\n",TailleImage) ;
  mexErrMsgTxt("Pas assez de m�moire pour traiter de ce probl�me\n") ;
  return ;
 }

 Derive_y = (double *)mxCalloc(TailleImage,sizeof(double)) ;
 if(Derive_y==NULL)
 {
  mxFree(Image) ;
  mxFree(Derive_x) ;
  printf("Probleme d'allocation pour %d bytes pour l'image cible\n",TailleImage) ;
  mexErrMsgTxt("Pas assez de m�moire pour traiter de ce probl�me\n") ;
  return ;
 }

 Derive_xy = (double *)mxCalloc(TailleImage,sizeof(double)) ;
 if(Derive_xy==NULL)
 {
  mxFree(Image) ;
  mxFree(Derive_x) ;
  mxFree(Derive_y) ;
  printf("Probleme d'allocation pour %d bytes pour l'image cible\n",TailleImage) ;
  mexErrMsgTxt("Pas assez de m�moire pour traiter de ce probl�me\n") ;
  return ;
 }

 // On remet l'image dans l'ordre
 pt = mxGetPr(prhs[0]) ;
 for( col=0 ; col<Ncol ; col++ )
 {
  for( lin=0 ; lin<Nlin ; lin++ )
  {
   n = (lin*Ncol) + col ;
   Image[ n ] = (*pt) ;
   pt++ ;
  }
 }

 switch(type_de_filtre)
 {
  case 1 :
  {
   castan(Image, Derive_xy, Derive_x, Derive_y, Nlin, Ncol, alpha) ;
  } break ;

  case 2 :
  {
   deriche(Image, Derive_xy, Derive_x, Derive_y, Nlin, Ncol, alpha) ;
  } break ;

  default :
  {
   pt = Image ; ptd = Derive_x ; for( n=0 ; n<TailleImage ; n++ ) (*ptd++) = (*pt++) ;
   pt = Image ; ptd = Derive_y ; for( n=0 ; n<TailleImage ; n++ ) (*ptd++) = (*pt++) ;
   pt = Image ; ptd = Derive_xy ; for( n=0 ; n<TailleImage ; n++ ) (*ptd++) = (*pt++) ;
  } break ;
 }


 plhs[0] = mxCreateDoubleMatrix(Nlin,Ncol,mxREAL) ;
 plhs[1] = mxCreateDoubleMatrix(Nlin,Ncol,mxREAL) ;
 plhs[2] = mxCreateDoubleMatrix(Nlin,Ncol,mxREAL) ;

 pt = mxGetPr(plhs[0]) ;

 for( col=0 ; col<Ncol ; col++ )
 {
  for( lin=0 ; lin<Nlin ; lin++ )
  {
   n = (lin*Ncol) + col ;
   (*pt) = Derive_x[n] ;
   pt++ ;
  }
 }

 pt = mxGetPr(plhs[1]) ;

 for( col=0 ; col<Ncol ; col++ )
 {
  for( lin=0 ; lin<Nlin ; lin++ )
  {
   n = (lin*Ncol) + col ;
   (*pt) = Derive_y[n] ;
   pt++ ;
  }
 }
 pt = mxGetPr(plhs[2]) ;

 for( col=0 ; col<Ncol ; col++ )
 {
  for( lin=0 ; lin<Nlin ; lin++ )
  {
   n = (lin*Ncol) + col ;
   (*pt) = Derive_xy[n] ;
   pt++ ;
  }
 }

 mxFree(Image) ;
 mxFree(Derive_x) ;
 mxFree(Derive_y) ;
 mxFree(Derive_xy) ;
}
