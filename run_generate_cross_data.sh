# Make sure your environment has enough GPUs for the model and attack

export CUDA_VISIBLE_DEVICES=0

base_save_dir="results"
method_name="EnsembleGCG"

# starling_7b mistral_7b_v2 openchat_3_5_1210
experiment_name="llama2_7b"


# chemical_biological misinformation_disinformation illegal cybercrime_intrusion harmful harassment_bullying

for semantic_type in hemical_biological misinformation_disinformation illegal cybercrime_intrusion harmful harassment_bullying
do
    behavior_type="standard"
    save_dir="${base_save_dir}/${method_name}/${experiment_name}/test_cases"
    prefix="st_${semantic_type}"

    behaviors_path="./data/behavior_datasets/harmbench_behaviors_text_val.csv"
    behavior_ids_subset="./scripts/content_subset/standard_behavior_ids_dev_${semantic_type}.txt"
    idx="${prefix}_dev"
    suffix_path="${save_dir}/suffix_${prefix}.json"
    python3 generate_ood_test_cases.py --behaviors_path $behaviors_path --suffix_path $suffix_path --behavior_type $behavior_type --save_dir $save_dir --idx $idx --behavior_ids_subset $behavior_ids_subset

    behaviors_path="./data/behavior_datasets/harmbench_behaviors_text_test.csv"
    behavior_ids_subset="./scripts/content_subset/standard_behavior_ids_test_${semantic_type}.txt"
    idx="${prefix}_test"
    suffix_path="${save_dir}/suffix_${prefix}.json"
    python3 generate_ood_test_cases.py --behaviors_path $behaviors_path --suffix_path $suffix_path --behavior_type $behavior_type --save_dir $save_dir --idx $idx --behavior_ids_subset $behavior_ids_subset

done