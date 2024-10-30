# Make sure your environment has enough GPUs for the model and attack

export CUDA_VISIBLE_DEVICES=0

base_save_dir="results"
method_name="EnsembleGCG"

# starling_7b mistral_7b_v2 openchat_3_5_1210
experiment_name="llama2_7b"

behaviors_path="./data/behavior_datasets/harmbench_behaviors_text_val.csv"

start_idx=0
end_idx=20 

behavior_ids_subset="./scripts/subset/standard_behavior_ids_dev.txt"
overwrite="True"
verbose="True"

prefix="st"
save_dir="${base_save_dir}/${method_name}/${experiment_name}/test_cases"
suffix_path="${save_dir}/suffix_${prefix}.json"
./scripts/generate_test_cases.sh $method_name $experiment_name $behaviors_path $save_dir $start_idx $end_idx $behavior_ids_subset $prefix $overwrite $verbose $suffix_path


