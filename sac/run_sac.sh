#!/bin/bash

environments=("HalfCheetah-v2" "Hopper-v2" "Swimmer-v2" "Walker2d-v2" "HumanoidStandup-v2" "Ant-v2" "Humanoid-v2" "InvertedDoublePendulum-v2" "InvertedPendulum-v2" "Reacher-v2")
seeds=(0 1 2)

num_envs=${#environments[@]}
num_seeds=${#seeds[@]}

# Calculate number of environments per window
envs_per_window=$((num_envs / 3))

# Create tmux session and split into 3 windows
tmux new-session -d -s "sac"

for ((i=0; i<3; i++)); do
    tmux split-window -v
    tmux select-layout tiled
done

# Loop through each window and run environments
for ((i=0; i<3; i++)); do
    tmux select-pane -t $i

    for ((j=0; j<envs_per_window; j++)); do
        start=$((i * envs_per_window + j))
        end=$((start + envs_per_window - 1))

        for ((k=start; k<=end; k++)); do
            tmux send-keys "source ~/.bashrc && conda activate pihjq" C-m
            tmux send-keys "echo 'Running ${environments[$k]}'" C-m

            for seed in "${seeds[@]}"; do
                tmux send-keys "echo 'Seed $seed'; python main.py --policy TD3 --env ${environments[$k]} --seed $seed" C-m
            done
        done
    done
done

tmux attach-session -t "sac"
