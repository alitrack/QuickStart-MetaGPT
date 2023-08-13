set -e  # 
#!/bin/bash

idea=$1

if [ -z "$idea" ]; then
    idea="Write a cli snake game"
fi

echo $idea

CURR_DIR=`pwd` 
echo $CURR_DIR
mkdir -p $CURR_DIR/workspace
mkdir -p $CURR_DIR/logs

# Check if key.yaml exists
if [ ! -f "key.yaml" ]; then
  echo "Error: key.yaml does not exist."
  exit 1
fi

# Check if OPENAI_API_KEY is set in key.yaml
if ! grep -q "^OPENAI_API_KEY:" key.yaml; then
  echo "Error: OPENAI_API_KEY line is missing in key.yaml."
  exit 1
fi

docker run --rm \
    -v $CURR_DIR/key.yaml:/app/metagpt/config/key.yaml \
    -v $CURR_DIR/workspace:/app/metagpt/workspace \
    -v $CURR_DIR/logs:/app/metagpt/logs\
    metagpt/metagpt:v0.3.1 \
    python startup.py "$idea"
    
# archive generated workspace and log to workspace.zip
zip -r $CURR_DIR/workspace.zip $CURR_DIR/workspace $CURR_DIR/logs 

echo "fin."