# Build the image for fuzzing the libjpeg-turbo project
echo y | python3 infra/helper.py build_image libjpeg-turbo

# Build all the fuzzers for the libjpeg-turbo project
python3 infra/helper.py build_fuzzers libjpeg-turbo --clean

# Create a directory for the corpus output
mkdir -p build/out/corpus_without_seeds

# Delete all .zip files in build/out/libjpeg-turbo
find build/out/libjpeg-turbo -name "*.zip" -type f -delete

# Run the fuzzer on the compress_fuzzer harness with initial seeds
python3 infra/helper.py run_fuzzer libjpeg-turbo compress_fuzzer --corpus-dir build/out/corpus_without_seeds

# Generate coverage report
python3 infra/helper.py build_fuzzers --sanitizer coverage libjpeg-turbo
python3 infra/helper.py coverage libjpeg-turbo --corpus-dir build/out/corpus_without_seeds --fuzz-target compress_fuzzer &
PID=$!
sleep 1800
kill -SIGTERM "$PID"

mv build/out/libjpeg-turbo/report/* ./coverage_report/w_o_seeds
