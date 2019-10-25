{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import Lib (app)
import Test.Hspec
import Test.Hspec.Wai

main :: IO ()
main = hspec spec

spec :: Spec
spec = with (return app) $ do
    describe "GET /even-or-odd" $ do
        it "responds with 200" $ do
            get "/even-or-odd/2" `shouldRespondWith` 200
        it "should determine whether the number is even or odd" $ do
            get "/even-or-odd/2" `shouldRespondWith` "\"even\""
            get "/even-or-odd/3" `shouldRespondWith` "\"odd\""
    describe "GET /arithmetic/:x/:operation/:y" $ do
       it "should response with 200" $ do
            get "/arithmetic/3/add/4" `shouldRespondWith` 200
       it "should perform the correct operation" $ do
            get "/arithmetic/3/add/4" `shouldRespondWith` "7"
            get "/arithmetic/3/subtract/4" `shouldRespondWith` "-1"
