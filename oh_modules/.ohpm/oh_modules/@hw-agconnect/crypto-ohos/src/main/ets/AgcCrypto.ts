import agccrypto from 'libagccrypto.so'

export class AgcCrypto {
    static ohGenPbkdf2(password: string, salt: string, count: number) {
        return agccrypto.ohGenPbkdf2(password, salt, count);
    }
}