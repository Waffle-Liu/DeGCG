import transformers
from baselines import get_method_class, init_method
import yaml
import argparse
import csv
import torch
import os
from os.path import join
from eval_utils import get_experiment_config
import pandas as pd
# Set this to disable warning messages in the generation mode.
transformers.utils.logging.set_verbosity_error()

import argparse

def parse_args():
    parser = argparse.ArgumentParser(description="Running red teaming with baseline methods.")

    parser.add_argument("--behaviors_path", type=str, default='./data/behavior_datasets/harmbench_behaviors_text_test.csv',
                        help="The path to the behaviors file")
    parser.add_argument("--suffix_path", type=str,
                        help="The path of the file storing suffix initialization")
    parser.add_argument("--behavior_type", type=str, default='standard')
    parser.add_argument("--save_dir", type=str, default='./results/EnsembleGCG/vicuna_7b_v1_5/test_cases',
                        help="The directory used for saving test cases")
    parser.add_argument("--idx", type=str, default='')
    parser.add_argument("--behavior_start_idx", type=int, default=None,
                        help="Start index for behaviors_path data (inclusive)")
    parser.add_argument("--behavior_end_idx", type=int, default=None,
                        help="End index for behaviors_path data (exclusive)")
    parser.add_argument("--behavior_ids_subset", type=str, default='',
                        help="An optional comma-separated list of behavior IDs, or a path to a newline-separated list of behavior IDs. If provided, this will override behavior_start_idx and behavior_end_idx for selecting a subset of behaviors.")
  
    
    args = parser.parse_args()
    return args


def main():
    # ========== load arguments and config ========== #
    args = parse_args()
    print(args)
    
    save_dir = os.path.abspath(args.save_dir)

    if os.path.exists(args.suffix_path):
        with open(args.suffix_path, 'r') as f:
            searched_string = json.load(f)['suffix']
    else:        
        searched_string = 19*"! "+"!"
    
    # ========== generate test cases ========== #
    # load behaviors csv
    with open(args.behaviors_path, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        behaviors = list(reader)
    if args.behavior_ids_subset:
        print(f"Selecting subset from provided behavior IDs: {args.behavior_ids_subset}")
        if os.path.exists(args.behavior_ids_subset):
            with open(args.behavior_ids_subset, 'r') as f:
                behavior_ids_subset = f.read().splitlines()
        else:
            behavior_ids_subset = args.behavior_ids_subset.split(',')
        behaviors = [b for b in behaviors if b['BehaviorID'] in behavior_ids_subset]

    # ==== generate ood test cases using searched adv strings =====
    b_type = args.behavior_type
    print("#Behaviors:" , len(behaviors))
    if 'multimodal' in args.behaviors_path:
        ood_cases = {}
        for b in behaviors:
            bid = b['BehaviorID']
            img = b['ImageFileName']
            if img.split('.')[-1] != 'png':
                img = img.split('.')[0] + '.png'
            ood_cases[bid] = [[img, b['Behavior']+' '+searched_string]]
            
    else:
        ood_cases = {}
        for b in behaviors:
            bid = b['BehaviorID']
            if b_type == 'all':
                ood_cases[bid] = [b['Behavior']+' '+searched_string]
            elif b_type == 'standard':
                if b['FunctionalCategory'] == 'standard':
                    ood_cases[bid] = [b['Behavior']+' '+searched_string]
            elif b_type == 'copyright':
                if b['FunctionalCategory'] == 'copyright':
                    ood_cases[bid] = [b['Behavior']+' '+searched_string]
            elif b_type == 'contextual':
                if b['FunctionalCategory'] == 'contextual':
                    ood_cases[bid] = [b['Behavior']+' '+searched_string]
    
    # ====== Save test cases and logs ======
    print("Saving outputs to: ", save_dir)
    import json
    idx = args.idx
    if 'multimodal' in args.behaviors_path:
        with open(os.path.join(save_dir, f'ood_cases_multimodal_{idx}.json'), 'w') as f1:
            json.dump(ood_cases, f1)
    else:
        with open(os.path.join(save_dir, f'ood_cases_{b_type}_{idx}.json'), 'w') as f1:
            json.dump(ood_cases, f1)

    print("Finished")

if __name__ == "__main__":
    main()
