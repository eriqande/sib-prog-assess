
# this should be run in the top directory of the repository
# (the directory that contains suppl and sib_assess_tex, etc:
for i in ./suppl/appendices/appendices.aux ./suppl/biggest_sibship/biggest_sibship.aux ./suppl/boxplots/boxplots.aux ./suppl/running_times/running_times.aux ./suppl/smearograms/smearograms.aux; do
	awk 'BEGIN {OFS="{"; } /^\\newlabel{[^s]/ {a=$0; split(a,b,/{/); print b[1],b[2],b[3],b[4],b[5],b[6] "}" }'  $i
done  > sib_assess_tex/suppl_cross_refs.aux
