for var in "$@"
do
CNVcaller /trial/results/genome_wide_"$var"/ginkgo/SegCopy /trial/results/genome_wide_"$var"/ginkgo/CNV1 trial/results/genome_wide_"$var"/ginkgo/CNV2
done

