export CUDA_VISIBLE_DEVICES=0

# Make sure your environment has enough GPUs for the model
base_save_dir="results"

# Often, the experiment name will be the same as the model name. It can be different for transfer attacks.
method_name="EnsembleGCG"
# starling_7b mistral_7b_v2 openchat_3_5_1210
experiment_name="llama2_7b"

# completion model name
model_name="llama2_7b"
#model_name="starling_7b"
#model_name="mistral_7b_v2"
#model_name="openchat_3_5_1210"

# vl models
#model_name='llava_v1_5'
#model_name="instructblip"
# close-source
#model_name="gpt-3.5-turbo-1106" 
#model_name="gpt-3.5-turbo-0613" 
#model_name="gpt-4-1106-preview" 

#behaviors_path="./data/behavior_datasets/harmbench_behaviors_text_val.csv"
behaviors_path="./data/behavior_datasets/harmbench_behaviors_text_test.csv"
#behaviors_path="./data/behavior_datasets/harmbench_behaviors_multimodal_all.csv"
max_new_tokens=512
incremental_update="False"

idx='st'

for mode in dev test
do
    id="${idx}_${mode}"
    experiment_dir="$base_save_dir/$method_name/$experiment_name"
    test_cases_path="$experiment_dir/test_cases/ood_cases_${id}.json"
    save_path="$experiment_dir/completions/${model_name}_${id}.json"

    ./scripts/generate_completions.sh $model_name $behaviors_path $test_cases_path $save_path $max_new_tokens $incremental_update

done

