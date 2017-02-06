calculate_concurrency() {
  MEMORY_AVAILABLE=${MEMORY_AVAILABLE-$(detect_memory 512)}
  WEB_MEMORY=${WEB_MEMORY-512}
  WEB_CONCURRENCY=${WEB_CONCURRENCY-$((MEMORY_AVAILABLE/WEB_MEMORY))}
  if (( WEB_CONCURRENCY < 1 )); then
    WEB_CONCURRENCY=1
  elif (( WEB_CONCURRENCY > 32 )); then
    WEB_CONCURRENCY=32
  fi
  WEB_CONCURRENCY=$WEB_CONCURRENCY
}

log_concurrency() {
  echo "Detected $MEMORY_AVAILABLE MB available memory, $WEB_MEMORY MB limit per process (WEB_MEMORY)"
  echo "Recommending WEB_CONCURRENCY=$WEB_CONCURRENCY"
}

detect_memory() {
  local default=$1
  local limit=$(ulimit -u)

  case $limit in
    256) echo "512";;      # Standard-1X
    512) echo "1024";;     # Standard-2X
    16384) echo "2560";;   # Performance-M
    32768) echo "14336";;  # Performance-L
    *) echo "$default";;
  esac
}

export PATH="$HOME/.heroku/ghostscript/bin:$HOME/.heroku/graphicsmagick/bin:$HOME/.heroku/node/bin:$PATH:$HOME/bin:$HOME/node_modules/.bin"
export LD_LIBRARY_PATH="$HOME/.heroku/jpeg/lib:$HOME/.heroku/libpng/lib:$HOME/.heroku/zlib/lib:$LD_LIBRARY_PATH"
echo "path is $PATH and ld_library_path $LD_LIBRARY_PATH"
echo "The result of gs command `gs --version`"
echo "The result of gm command `gm version`"
export NODE_HOME="$HOME/.heroku/node"
export NODE_ENV=${NODE_ENV:-production}

calculate_concurrency

export MEMORY_AVAILABLE=$MEMORY_AVAILABLE
export WEB_MEMORY=$WEB_MEMORY
export WEB_CONCURRENCY=$WEB_CONCURRENCY

if [ "$LOG_CONCURRENCY" = "true" ]; then
  log_concurrency
fi
