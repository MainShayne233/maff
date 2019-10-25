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

data User = User
  { userId        :: Integer
  , userFirstName :: String
  , userLastName  :: String
  } deriving (Eq, Show)

$(deriveJSON defaultOptions ''User)

type API = "users" :> Get '[JSON] [User]
       :<|> "add" :> Capture "x" Integer :> Capture "y" Integer :> Get '[JSON] Integer


startApp :: IO ()
startApp = run 8080 app

app :: Application
app = serve api server

api :: Proxy API
api = Proxy

server :: Server API
server = getUsers :<|> add

  where getUsers :: Handler [User]
        getUsers = return [ User 1 "Isaac" "Newton"
               , User 2 "Albert" "Einstein"
               ]

        add :: Integer -> Integer -> Handler Integer
        add x y = return (x + y)
