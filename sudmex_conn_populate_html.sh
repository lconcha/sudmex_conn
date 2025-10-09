#!/bin/bash

# Script to generate experiments.html from folder structure
# Usage: ./generate_experiments.sh [base_directory]
# Default base directory is current directory

BASE_DIR="${1:-.}"
OUTPUT_FILE="experiments.html"

# Start building the experiments JavaScript object
experiments_js=""
buttons_html=""
counter=1

# Find all qc.gif files in sub-*/ses-* structure
while IFS= read -r gif_path; do
    # Get the directory path
    exp_dir=$(dirname "$gif_path")
    
    # Extract sub-* and ses-* from path
    sub_dir=$(basename "$(dirname "$exp_dir")")
    ses_dir=$(basename "$exp_dir")
    exp_name="${sub_dir}/${ses_dir}"
    
    # Get relative paths from base directory
    rel_gif_path=$(realpath --relative-to="$BASE_DIR" "$gif_path")
    
    # Get the PNG file path
    png_path="${exp_dir}/connectome_sift2_atlas_116.png"
    rel_png_path=$(realpath --relative-to="$BASE_DIR" "$png_path")
    
    # Generate experiment ID
    exp_id="exp${counter}"
    
    # Add to experiments object
    experiments_js+="        '${exp_id}': {
            name: '${exp_name}',
            gif: '${rel_gif_path}',
            png: '${rel_png_path}'
        },
"
    
    # Add button
    buttons_html+="        <button class=\"experiment-btn\" onclick=\"showExperiment('${exp_id}', this)\">${exp_name}</button>
"
    
    ((counter++))
done < <(find "$BASE_DIR" -path "*/sub-*/ses-*/qc.gif" -type f | sort)

# Remove trailing comma from last experiment
experiments_js=$(echo "$experiments_js" | sed '$ s/,$//')

# Generate the HTML file
cat > "$OUTPUT_FILE" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Experiment Results</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        h1 {
            color: #333;
            text-align: center;
        }
        .experiment-list {
            background: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .experiment-list h2 {
            margin-top: 0;
            color: #555;
        }
        .experiment-btn {
            display: inline-block;
            margin: 5px;
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s;
        }
        .experiment-btn:hover {
            background-color: #45a049;
        }
        .experiment-btn.active {
            background-color: #2196F3;
        }
        .viewer {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            text-align: center;
        }
        .viewer h3 {
            color: #333;
            margin-top: 0;
        }
        .viewer img {
            max-width: 100%;
            height: auto;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .no-selection {
            color: #999;
            font-style: italic;
        }
    </style>
</head>
<body>
    <h1>Experiment Results</h1>
    
    <div class="experiment-list">
        <h2>Select an Experiment:</h2>
EOF

# Insert the buttons
echo "$buttons_html" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" << 'EOF'
    </div>
    
    <div class="viewer">
        <div id="content">
            <p class="no-selection">Select an experiment to view its results</p>
        </div>
    </div>

    <script>
        const experiments = {
EOF

# Insert the experiments object
echo "$experiments_js" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" << 'EOF'
        };

        function showExperiment(expId, button) {
            const exp = experiments[expId];
            const content = document.getElementById('content');
            
            content.innerHTML = `
                <h3>${exp.name}</h3>
                <img src="${exp.gif}" alt="${exp.name} - QC">
                <br><br>
                <img src="${exp.png}" alt="${exp.name} - Connectome">
            `;
            
            // Update active button
            document.querySelectorAll('.experiment-btn').forEach(btn => {
                btn.classList.remove('active');
            });
            button.classList.add('active');
        }
    </script>
</body>
</html>
EOF

echo "Generated $OUTPUT_FILE with $((counter-1)) experiments"