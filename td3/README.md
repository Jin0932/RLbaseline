
conda env create -f environment.yaml

bash ./run_td3.sh
bash ./run_ddpg.sh


tmux attach -t td3
tmux attach -t ddpg
