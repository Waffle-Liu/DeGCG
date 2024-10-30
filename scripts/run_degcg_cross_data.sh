# Make sure your environment has enough GPUs for the model and attack

export CUDA_VISIBLE_DEVICES=0

base_save_dir="results"
method_name="EnsembleGCG"

# starling_7b mistral_7b_v2 openchat_3_5_1210
experiment_name="llama2_7b"

behaviors_path="./data/behavior_datasets/harmbench_behaviors_text_val.csv"
save_dir="${base_save_dir}/${method_name}/${experiment_name}/test_cases"

start_idx=0
end_idx=20 

overwrite="True"
verbose="True"

for semantic_type in chemical_biological misinformation_disinformation illegal cybercrime_intrusion harmful harassment_bullying
do
    prefix="st_${semantic_type}"
    suffix_path="${save_dir}/suffix_${prefix}.json"
    behavior_ids_subset="./scripts/content_subset/standard_behavior_ids_dev_${semantic_type}.txt"
    
    ./scripts/generate_test_cases.sh $method_name $experiment_name $behaviors_path $save_dir $start_idx $end_idx $behavior_ids_subset $prefix $overwrite $verbose $suffix_path

done