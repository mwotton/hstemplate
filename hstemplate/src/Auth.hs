{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}
module Auth where

import           Config
import qualified Data.HashMap.Strict                  as HM
import           Network.HTTP.Types.Status
import           Network.Wai                          (Middleware, pathInfo,
                                                       responseLBS)
import           Network.Wai.Middleware.Auth
import           Network.Wai.Middleware.Auth.Provider



genAuthMiddleware :: Config -> IO Middleware
genAuthMiddleware Config{..} = do
  let settings = setAuthProviders (HM.fromList $ fmap (getProviderName &&& id) authProviders) defaultAuthSettings
  authMid <- mkAuthMiddleware settings
  pure $ addLogout settings . authMid
  -- we also want a layer that will catch "/auth/logout" and delete a cookie.


addLogout :: AuthSettings -> Middleware
addLogout settings base req responseFunc =
  case pathInfo req of
    ["auth","logout"] -> responseFunc $ responseLBS status200 [getDeleteSessionHeader settings] "Ok,logged out"
    _ -> base req responseFunc
