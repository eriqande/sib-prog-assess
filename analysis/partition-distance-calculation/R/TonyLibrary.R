
#########################################################################

simulate.ind<-function(n1,na,ni) {
	
	# simulate ni individuals, with nl loci, na equi-alleles

	gene.vec<-floor(na*runif(2*ni*nl)+1)
	gene.table<-matrix(gene.vec,ni,2*nl)

	return(gene.table)
}

#########################################################################

simulate.offspring<-function(p1,p2) {

	# p1 (p2) = vector of 2*nl genes

	nl<-length(p1)/2
	p0<-rep(0,2*nl)
	for (i in c(1:nl)) {
		u<-floor(2*runif(2)+1)
		p0[2*i-1]<-p1[2*(i-1)+u[1]]
		p0[2*i]<-p2[2*(i-1)+u[2]] 
	}
	return(p0)
}


#########################################################################

convert.subsets<-function(sub.list) {

	n<-length(sub.list)
	i.max<-0
	ne<-0
	for (i in c(1:n)) {
		v<-sub.list[[i]]
		ne<-ne+length(v)
		i.max<-max(i.max,max(v))
	}
	ia<-rep(0,ne)
	ja<-ia
	ar<-rep(1,ne)
	k<-0
	for (i in c(1:n)) {
		v<-sub.list[[i]]
		for (j in c(1:length(v))) {
			k<-k+1
			ia[k]<-v[j]
			ja[k]<-i
		}
	}
	return(list(i.max=i.max,ne=ne,n=n,ia=ia,ja=ja,ar=ar))
}
		

#########################################################################

convert.subsets.2<-function(sub.list.1,sub.list.2) {

	# create cost matrix for bipartite assignment problem

	n1<-length(sub.list.1)
	n2<-length(sub.list.2)

	cost.parameters<-rep(0,n1*n2)

	k<-0
	for (i in c(1:n1)) {
	for (j in c(1:n2)) {
		k<-k+1
		cost.parameters[k]<- (length(sub.list.1[[i]])
		+length(sub.list.2[[j]])								-length(unique(c(sub.list.1[[i]],sub.list.2[[j]]))))
	}}
	
	n.cols<-n1*n2	
	n.rows<-n1+n2

	ia <- NULL
	ja <- NULL
	ar<-NULL

	for (i in c(1:n1)) {
		ia<-c(ia,rep(i,n2))
		ja<-c(ja, (i-1)*n2 + c(1:n2))
		ar<-c(ar,rep(1,n2)) 		
	}
	for (j in c(1:n2)) {
		ia<-c(ia,rep(n1+j,n1))
		ja<-c(ja, n2*c(1:n1)+(j-n2))
		ar<-c(ar,rep(1,n1)) 		
	}

	return(list(ne=length(ar),n1=n1,n2=n2,n.rows=n.rows,n.cols=n.cols,
	ia=ia,ja=ja,ar=ar,cost.parameters=cost.parameters))
}

################################################################################

MSC4 <- function(mm) {

	nl<-dim(mm)[2]/2
	ni<-dim(mm)[1]

	np<-ni*(ni-1)/2

	sub.list <- NULL
	for (i in c(1:np)) {sub.list<-append(sub.list,list(NULL))}
	set.list <-NULL
	for (i in c(1:nl)) {set.list<-append(set.list,list(NULL))}	
	
	k<-0
	for (i in c(1:(ni-1))) {
	for (j in c((i+1):ni)) {
		k<-k+1
		sub.list[[k]]<-c(i,j)
		for (ii in c(1:nl)) {
			set.list[[ii]]<-unique(c(mm[i,(2*ii-1):(2*ii)], 					mm[j,(2*ii-1):(2*ii)]))
		}

		for (ii in c(1:ni)) {
			if ( (ii!=i) & (ii!=j) ) {	
				foundit<-0 
				flag<-0
				jj<-0
				while (flag==0)	{			
					jj<-jj+1
					if (  (sum(mm[ii,(2*jj-1)]==set.list[[jj]]) 					== 0) | 											(sum(mm[ii,(2*jj)]==set.list[[jj]]) == 0) ) 					{foundit<-1}
					if ( (foundit==1) | (jj==nl) ) {flag<-1}
				}
				if (foundit==0) {sub.list[[k]]<-								c(sub.list[[k]],ii)}
			}
		}
	}}
	return(sub.list)						
}



#########################################################################


BA.function<-function(a.obj) {

	n.rows<-a.obj$n.rows
	n.cols<-a.obj$n.cols


	lp <- lpx_create_prob();
	lpx_set_class(lp, LPX_MIP);
	lpx_set_prob_name(lp, "sample");
	lpx_set_obj_dir(lp, LPX_MAX);

	# row constraints              

	lpx_add_rows(lp, n.rows);
	for (i in c(1:n.rows)) {
		lpx_set_row_bnds(lp, i, LPX_UP, 1.0, 1.0);
	}

	# column constraints

	lpx_add_cols(lp, n.cols);
	for (j in c(1:n.cols)) {
		lpx_set_col_bnds(lp, j, LPX_DB, 0.0, 1.0);
		lpx_set_col_kind(lp, j, LPX_IV);
		lpx_set_obj_coef(lp, j, a.obj$cost.parameters[j]);
	}

	lpx_load_matrix(lp, a.obj$ne, a.obj$ia, a.obj$ja, a.obj$ar);
	lpx_simplex(lp);
	lpx_integer(lp);

	answer<-rep(0,n.cols)
	# eric put this in and commented out the line below it 'cuz it was crashing with a new version of glpk...
	for(j in 1:n.cols) {boing<-lpx_mip_col_val(lp,j); if(!is.null(boing)) {answer[j]<-boing}}
#	for (j in c(1:n.cols)) {answer[j]<-lpx_mip_col_val(lp,j)}
	v<-lpx_get_obj_val(lp)
	lpx_delete_prob(lp)
	return(list(v=v,answer=answer))

}

#########################################################################

MCP.function<-function(a.obj) {

	n.rows<-a.obj$i.max
	n.cols<-a.obj$n

	
	lp <- lpx_create_prob();
	lpx_set_class(lp, LPX_MIP);
	lpx_set_prob_name(lp, "sample");
	lpx_set_obj_dir(lp, LPX_MIN);

	# row constraints              

	lpx_add_rows(lp, n.rows);
	for (i in c(1:n.rows)) {
		lpx_set_row_bnds(lp, i, LPX_LO, 1.0, 1.0);
	}

	# column constraints

	lpx_add_cols(lp, n.cols);
	for (j in c(1:n.cols)) {
		lpx_set_col_bnds(lp, j, LPX_DB, 0.0, 1.0);
		lpx_set_col_kind(lp, j, LPX_IV);
		lpx_set_obj_coef(lp, j, 1.0);
	}

	lpx_load_matrix(lp, a.obj$ne, a.obj$ia, a.obj$ja, a.obj$ar);
	lpx_simplex(lp);
	lpx_integer(lp);

	answer<-rep(0,n.cols)
	for (j in c(1:n.cols)) {answer[j]<-lpx_mip_col_val(lp,j)}
	lpx_delete_prob(lp)
	return(answer)

}

#########################################################################

