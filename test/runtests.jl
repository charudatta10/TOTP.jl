using Test
using TOTP

const secret = UInt8.(b"12345678901234567890")

@testset "correctness" begin # https://tools.ietf.org/html/rfc6238#appendix-B
    @test genotp(secret, time=0x00000001, ndigits=8) == "94287082"
    @test genotp(secret, time=0x27BC86AA, ndigits=8) == "65353130"
end

@testset "behaviour" begin
    @test length(genotp(secret, time=0x27BC86AA, ndigits=6)) == 6
    @test length(gensecret(10)) == 16
    @test length(genotp6(secret)) == 6
    @test genotp(secret) in genotp6(secret)
end
