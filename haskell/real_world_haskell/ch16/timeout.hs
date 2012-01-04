import System.Cmd
import System.Timeout

main = timeout 1 $ system "sleep 3"
