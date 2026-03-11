#!/bin/bash
set -e

cd /home/liam/code/make_mkv

# Activate conda environment
source /home/liam/anaconda3/etc/profile.d/conda.sh
conda activate yt-dl

# Create output directory
mkdir -p outputs

# Process each video
for video in to_process/*.mp4; do
    base=$(basename "$video" .mp4)
    en_sub="to_process/${base}.en.srt"
    hu_sub="to_process/${base}.hu.srt"
    output="outputs/${base}.mkv"
    
    echo "Processing: $base"
    
    ffmpeg -y -i "$video" -i "$hu_sub" -i "$en_sub" \
        -c:v copy -c:a copy -c:s srt \
        -map 0:v -map 0:a -map 1:s -map 2:s \
        -metadata:s:a:0 language=hun \
        -metadata:s:s:0 language=hun \
        -metadata:s:s:1 language=eng \
        "$output"
    
    echo "Done: $output"
done

echo "All videos processed!"
