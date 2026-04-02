#include "mini-gmp.h"
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

void random_mod_n(mpz_t r, const mpz_t n) {

    int fd = open("/dev/urandom", O_RDONLY);

    size_t bytes = (mpz_sizeinbase(n, 2) + 7) / 8;

    unsigned char *buf = malloc(bytes);

    mpz_t gcd;
    mpz_init(gcd);

    do {

        read(fd, buf, bytes);

        mpz_import(r, bytes, 1, 1, 0, 0, buf);
        mpz_mod(r, r, n);

        mpz_gcd(gcd, r, n);

    } while(mpz_cmp_ui(r,0)==0 || mpz_cmp_ui(gcd,1)!=0);

    mpz_clear(gcd);
    free(buf);
    close(fd);
}

char* paillier_encrypt(const char* m_str, const char* n_str) {

    mpz_t m,n,n2,r,rn,gm,c,gcd;

    mpz_init(m);
    mpz_init(n);
    mpz_init(n2);
    mpz_init(r);
    mpz_init(rn);
    mpz_init(gm);
    mpz_init(c);
    mpz_init(gcd);

    mpz_set_str(m,m_str,10);
    mpz_set_str(n,n_str,10);

    mpz_mul(n2,n,n);

    // gm = 1 + m*n
    mpz_mul(gm,m,n);
    mpz_add_ui(gm,gm,1);
    mpz_mod(gm,gm,n2);

    // generate r with gcd(r,n)=1
    do {
        random_mod_n(r,n);
        mpz_gcd(gcd,r,n);
    } while(mpz_cmp_ui(gcd,1)!=0);

    // rn = r^n mod n²
    mpz_powm(rn,r,n,n2);

    // c = gm * rn mod n²
    mpz_mul(c,gm,rn);
    mpz_mod(c,c,n2);

    char* result = malloc(4096);
    mpz_get_str(result,10,c);

    mpz_clear(m);
    mpz_clear(n);
    mpz_clear(n2);
    mpz_clear(r);
    mpz_clear(rn);
    mpz_clear(gm);
    mpz_clear(c);
    mpz_clear(gcd);

    return result;
}

void paillier_free(char* ptr){
    free(ptr);
}