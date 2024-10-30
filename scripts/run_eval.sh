export CUDA_VISIBLE_DEVICES=0

# Make sure your environment has enough GPUs for the classifier (Llama 2 13B)
base_save_dir="results"

method_name="EnsembleGCG"
# Often, the experiment name will be the same as the model name. It can be different for transfer attacks.
# starling_7b mistral_7b_v2 openchat_3_5_1210
experiment_name="llama2_7b"


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


cls_path="cais/HarmBench-Llama-2-13b-cls"
#cls_path="cais/HarmBench-Llama-2-13b-cls-multimodal-behaviors"

prefix='st'
id="${prefix}_dev"
behaviors_path="./data/behavior_datasets/harmbench_behaviors_text_val.csv"
completions_path="${base_save_dir}/${method_name}/${experiment_name}/completions/${model_name}_${id}.json" # output file from Step 2
save_path="${base_save_dir}/${method_name}/${experiment_name}/results/${model_name}_${id}.json"
./scripts/evaluate_completions.sh $cls_path $behaviors_path $completions_path $save_path

id="${prefix}_test"
behaviors_path="./data/behavior_datasets/harmbench_behaviors_text_test.csv"
completions_path="${base_save_dir}/${method_name}/${experiment_name}/completions/${model_name}_${id}.json" # output file from Step 2
save_path="${base_save_dir}/${method_name}/${experiment_name}/results/${model_name}_${id}.json"
./scripts/evaluate_completions.sh $cls_path $behaviors_path $completions_path $save_path


