{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
module Lib
    ( startApp
    , app
    ) where

import Data.Aeson
import Data.Aeson.TH
import Network.Wai
import Network.Wai.Handler.Warp
import Servant
import Web.Internal.HttpApiData

data Operation = Add | Subtract deriving (Show, Bounded, Enum)

instance FromHttpApiData Operation where parseUrlPiece = parseBoundedTextData

data User = User
  { userId        :: Integer
  , userFirstName :: String
  , userLastName  :: String
  } deriving (Eq, Show)


$(deriveJSON defaultOptions ''User)

type API = "users" :> Get '[JSON] [User]
       :<|> "arithmetic" :> Capture "x" Integer :> Capture "operation" Operation :> Capture "y" Integer :> Get '[JSON] Integer


startApp :: IO ()
startApp = run 8080 app

app :: Application
app = serve api server

api :: Proxy API
api = Proxy

server :: Server API
server = getUsers :<|> arithmetic

  where getUsers :: Handler [User]
        getUsers = return [ User 1 "Isaac" "Newton"
               , User 2 "Albert" "Einstein"
               ]

        arithmetic :: Integer -> Operation -> Integer -> Handler Integer
        arithmetic x Add y = return (x + y)
        arithmetic x Subtract y = return(x - y)
