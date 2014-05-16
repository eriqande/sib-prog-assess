
# this should be run in the directory:
# /Users/eriq/prj/AlmudevarCollab/SibProgramsEvaluation/doc
for i in 1 2 3 4; do
	awk 'BEGIN {OFS="{"; } /^\\newlabel{[^s]/ {a=$0; split(a,b,/{/); print b[1],b[2],b[3],b[4],b[5],b[6] "}" }' suppl$i/suppl$i.aux
done > sib_assess_tex/suppl_cross_refs.aux


