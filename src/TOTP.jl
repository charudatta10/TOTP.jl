__precompile__()

module TOTP

using SHA
using CodecBase

export genotp, genotp6, gensecret, genuri

function hmac(key::Vector{UInt8}, msg::Vector{UInt8}, hash, blocksize=64)
    if length(key) > blocksize
        key = hash(key)
    end

    pad = blocksize - length(key)

    if pad > 0
        resize!(key, blocksize)
        key[end-pad+1:end] = 0
    end

    o_key_pad = key .⊻ 0x5c
    i_key_pad = key .⊻ 0x36

    hash([o_key_pad; hash([i_key_pad; msg])])
end

hmac(hash::Function, bs=64) = (key, msg, blocksize=bs) -> hmac(key, msg, hash, blocksize)

"generate opt code with secret"
function genotp(secret::Vector{UInt8}; ndigits=6, hash=hmac(sha1),
                                       time=floor(Int, Libc.time() / 30))
    message = hex(time, 16) |> hex2bytes
    hash = hash(secret, message)

    offset = hash[length(hash)] & 0x0f
    binary = (Int(hash[offset+1] & 0x7f) << 24) | (Int(hash[offset+2] & 0xff) << 16) | (Int(hash[offset+3] & 0xff) << 8) | (hash[offset+4] & 0xff)
    otp = binary % 10 ^ ndigits
    dec(otp, ndigits)
end

genotp(secret::String; kwargs...) = genotp(transcode(Base32Decoder(), secret); kwargs...)

"generate 6 time steps near now so that you can match any one of them, this is useful when your user need 1 minute to input the password"
genotp6(secret; kwargs...) = map(x->genotp(secret; time=floor(Int, Libc.time() / 30)+x, kwargs...), -3:2)

"generate a random secret string"
gensecret(len=10) = transcode(Base32Encoder(), rand(UInt8, len)) |> String

"generate an URI that can be recognized by Google Authenticator app when encoded as QR code"
genuri(secret, name) = "otpauth://totp/$name?secret=$secret"

end # module TOTP
