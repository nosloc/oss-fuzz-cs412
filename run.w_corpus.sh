# Build the image for fuzzing the libjpeg-turbo project
echo y | python3 infra/helper.py build_image libjpeg-turbo

# Build all the fuzzers for the libjpeg-turbo project
python3 infra/helper.py build_fuzzers libjpeg-turbo --clean

# Create a directory for the corpus output
mkdir build/out/corpus_with_initial_seeds

# Run the fuzzer on the compress_fuzzer harness with initial seeds
# timeout 30s for test purposes, to make sure everything works properly
timeout 5s python3 infra/helper.py run_fuzzer libjpeg-turbo compress_fuzzer --corpus-dir build/out/corpus_with_initial_seeds

# Generate the coverage report
python3 infra/helper.py build_fuzzers --sanitizer coverage libjpeg-turbo
python3 infra/helper.py coverage libjpeg-turbo --corpus-dir build/out/corpus_with_initial_seeds --fuzz-target compress_fuzzer
