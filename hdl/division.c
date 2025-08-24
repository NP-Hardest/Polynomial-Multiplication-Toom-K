#include <stdio.h>
#include <stdint.h>


static void print32(uint32_t x){
    for(int b=31;b>=0;--b) putchar((x>>b)&1 ? '1':'0');
}


static void ExactDivOnePlusX_L2R(uint32_t *c, long n){
    uint32_t t = 0;                
    for(long i=0;i<n;++i){
        t ^= c[i];                 
        // t ^= t >> 1;
        t ^= t >> 2;
        t ^= t >> 4;
        t ^= t >> 8;
        t ^= t >> 16;             
        c[i] = t;                   
        t = (t) << 30;          
    }
}

/* Multiply by (1+x) (for verification) in left->right storage */
static void MulByOnePlusX_L2R(const uint32_t *q, uint32_t *r, long n){
    for(long i=0;i<n;++i) r[i]=0;
    for(long i=0;i<n;++i){
        r[i] ^= q[i];            
        r[i] ^= (q[i] >> 2);       
        if(i+1<n) r[i+1] ^= (q[i] & 1u) << 30;
    }
}

int main(void){

    uint32_t orig[2] = { 0xA0000001u, 0x40000000u };
    uint32_t c[2]    = { orig[0], orig[1] };

    printf("Convention: MSB=lowest degree in each word (left->right).\n");
    printf("Words: c[0]=x^0..x^31, c[1]=x^32..x^63 (MSB..LSB)\n\n");

    printf("Before (orig)  c[0]: "); print32(c[0]); putchar('\n');
    printf("                c[1]: "); print32(c[1]); putchar('\n');

    ExactDivOnePlusX_L2R(c, 2);

    printf("\nAfter division  q[0]: "); print32(c[0]); putchar('\n');
    printf("                q[1]: "); print32(c[1]); putchar('\n');

    uint32_t recon[2];
    MulByOnePlusX_L2R(c, recon, 2);
    printf("\nReconstructed r[0]: "); print32(recon[0]); putchar('\n');
    printf("               r[1]: "); print32(recon[1]); putchar('\n');

    printf("\nMatch original? %s\n",
        (recon[0]==orig[0] && recon[1]==orig[1]) ? "YES" : "NO");
    return 0;
}
