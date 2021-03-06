-- |
-- Module      : Crypto.MAC.HMAC
-- License     : BSD-style
-- Maintainer  : Vincent Hanquez <vincent@snarc.org>
-- Stability   : experimental
-- Portability : unknown
--
-- provide the HMAC (Hash based Message Authentification Code) base algorithm.
-- http://en.wikipedia.org/wiki/HMAC
--
module Crypto.MAC.HMAC
	( hmac
	) where

import Data.ByteString (ByteString)
import qualified Data.ByteString as B
import Data.Bits (xor)

-- | compute a MAC using the supplied hashing function
hmac :: (ByteString -> ByteString) -> Int -> ByteString -> ByteString -> ByteString
hmac f blockSize secret msg = f $ B.append opad (f $ B.append ipad msg) where
	opad = B.map (xor 0x5c) k'
	ipad = B.map (xor 0x36) k'

	k' = B.append kt pad
	kt = if B.length secret > fromIntegral blockSize then f secret else secret
	pad = B.replicate (fromIntegral blockSize - B.length kt) 0
