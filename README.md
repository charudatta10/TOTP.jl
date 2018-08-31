TOTP.jl
=======

[![Build Status](https://travis-ci.org/ylxdzsw/TOTP.jl.svg?branch=master)](https://travis-ci.org/ylxdzsw/TOTP.jl)
![Julia v1.0 ready](https://blog.ylxdzsw.com/_static/julia_v1.0_ready.svg)

### Installation

```julia
Pkg.clone("https://github.com/ylxdzsw/TOTP.jl")
```

### Usage

```julia
using TOTP

# generate a random key (note this method use Julia's built-in random number generator, which is not crypto safe)
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
