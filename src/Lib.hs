{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
module Lib
    ( startApp
    , app
    ) where

import Data.Proxy
import Network.Wai
import Network.Wai.Handler.Warp
import Servant
import Web.Internal.HttpApiData

data Operation = Add | Subtract deriving (Show, Bounded, Enum)

instance FromHttpApiData Operation where parseUrlPiece = parseBoundedTextData

type API = "even-or-odd" :> Capture "x" Integer :> Get '[JSON] String
       :<|> "arithmetic" :> Capture "x" Integer :> Capture "operation" Operation :> Capture "y" Integer :> Get '[JSON] Integer


startApp :: IO ()
startApp = run 8080 app

app :: Application
app = serve api server

api :: Proxy API
api = Proxy

server :: Server API
server = evenOrOdd :<|> arithmetic

  where evenOrOdd :: Integer -> Handler String
        evenOrOdd x = return (if mod x 2 == 0 then "even" else "odd")

        arithmetic :: Integer -> Operation -> Integer -> Handler Integer
        arithmetic x Add y = return (x + y)
        arithmetic x Subtract y = return(x - y)
