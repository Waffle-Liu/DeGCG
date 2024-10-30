# Make sure your environment has enough GPUs for the model and attack

export CUDA_VISIBLE_DEVICES=0

base_save_dir="results"
method_name="EnsembleGCG"

# starling_7b mistral_7b_v2 openchat_3_5_1210
experiment_name="llama2_7b"

behaviors_path="./data/behavior_datasets/harmbench_behaviors_text_val.csv"
#behaviors_path="./data/behavior_datasets/harmbench_behaviors_text_test.csv"
#behaviors_path="./data/behavior_datasets/harmbench_behaviors_multimodal_all.csv"

behavior_type="standard"
save_dir="${base_save_dir}/${method_name}/${experiment_name}/test_cases"
prefix="st"

idx="${prefix}_dev"
suffix_path="${save_dir}/suffix_${prefix}.json"
python3 generate_ood_test_cases.py --behaviors_path $behaviors_path --suffix_path $suffix_path --behavior_type $behavior_type --save_dir $save_dir --idx $idx

behaviors_path="./data/behavior_datasets/harmbench_behaviors_text_test.csv"
idx="${prefix}_test"
suffix_path="${save_dir}/suffix_${prefix}.json"
python3 generate_ood_test_cases.py --behaviors_path $behaviors_path --suffix_path $suffix_path --behavior_type $behavior_type --save_dir $save_dir --idx $idx
