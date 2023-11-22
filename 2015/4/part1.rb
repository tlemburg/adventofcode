#!/usr/bin/env ruby

require 'digest'

input = 'iwrupvqb'
z = 1

while true
  if (Digest::MD5.hexdigest "#{input}#{z}").start_with?('00000')

    puts z
    exit
  end
  z += 1
end

exit





s = []
k = []

s.concat [7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22]
s.concat [ 5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20 ]
s.concat [4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23]
s.concat [ 6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21 ]

(0..63).each do |i|
  k.push (2**32 * Math.sin(i+1).abs).floor
end

a0 = 0x67452301
b0 = 0xefcdab89
c0 = 0x98badcfe
d0 = 0x10325476

padded_message = input.bytes.map {|byte| byte.to_s(2).rjust(8, '0')}.join

mlength = padded_message.length

padded_message = "#{padded_message}1"

while padded_message.length % 512 != 448
  padded_message = "#{padded_message}0"
end

length_in_64b = mlength.to_s(2).rjust(64, '0')

message = "#{padded_message}#{length_in_64b}"

chunks = message.length / 512

(0...chunks).each do |chunk_num|
  chunk = message[chunk_num*512...chunk_num*512+512]
  words = (0...16).map do |i|
    chunk[32*i...32*i+32]
  end

  a = a0
  b = b0
  c = c0
  d = d0

  (0..63).each do |i|
    f, g = case i
            when (0..15)
            [(b & c) | ((~b) & d), i]
            when (16..31)
            [(d & b) | ((~d) & c), (5*i+1) % 16]
            when (32..47)
            [b ^ c ^ d, (3*i+5)%16]
            when (48..63)
            [c ^ (b | (~d)), (7*i)%16]
            end

    puts '----'
    puts 'F value'
    puts i
    puts f.to_s(16)
    puts '-----'
    
    f = (f + a + k[i] + words[g].to_i(2)) % (2**32)
    a = d
    d = c
    c = b

    f_rotated = (f.to_s(2).rjust(32, '0')[s[i]..-1] || '') + (f.to_s(2).rjust(32, '0')[0..s[i]-1] || '')

    b = (b + f_rotated.to_i(2)) % (2**32)

    puts i
    puts a.to_s(16)
    puts b.to_s(16)
    puts c.to_s(16)
    puts d.to_s(16)

  end

  a0 = (a0 + a) % (2**32)
  b0 = (b0 + b) % (2**32)
  c0 = (c0 + c) % (2**32)
  d0 = (d0 + d) % (2**32)

end

digest = "#{a0.to_s(16)}#{b0.to_s(16)}#{c0.to_s(16)}#{d0.to_s(16)}"


puts digest
