TOTP.jl
=======

### Installation

```julia
Pkg.clone("https://github.com/ylxdzsw/TOTP.jl")
```

### Usage

```julia
using TOTP

# generate a random key
key = gensecret()

# share it to your user by a QR code
uri = genuri(key, "user@domain")
# make qr code of the uri

# generate an otp
genotp(key)

# generate 6 otps near now so you can match any one of them.
if user_input in genotp6(key)
    # authentication passed
end
```