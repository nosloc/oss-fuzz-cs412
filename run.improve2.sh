sudo apt update && sudo apt install -y git cmake build-essential gcc g++ nasm curl unzip
git clone git@github.com:nosloc/oss-fuzz-cs412.git
cd oss-fuzz-cs412

# Build the image for fuzzing the libjpeg-turbo project
echo y | python3 infra/helper.py build_image libjpeg-turbo

# Build all the fuzzers for the libjpeg-turbo project
python3 infra/helper.py build_fuzzers libjpeg-turbo --clean

# Create a directory for the corpus output
mkdir -p build/out/corpus_with_initial_seeds

# Run the fuzzer on the new saveimg_fuzzer harness with initial seeds
python3 infra/helper.py run_fuzzer libjpeg-turbo saveimg_fuzzer --corpus-dir build/out/corpus_with_initial_seeds

# Generate the coverage report
python3 infra/helper.py build_fuzzers --sanitizer coverage libjpeg-turbo
python3 infra/helper.py coverage libjpeg-turbo --corpus-dir build/out/corpus_with_initial_seeds --fuzz-target saveimg_fuzzer
