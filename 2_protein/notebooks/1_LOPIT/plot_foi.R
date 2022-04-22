library(biobroom)
library(MSnbase)
library(dplyr)

update_loc_names <- function(names){
  names <- Hmisc::capitalize(tolower(names))
  names <- recode(names, 'Pm'='PM', 'Er'='ER')
  return(names)
}

plot_tsne <- function(obj,
                      fcol='markers',
                      foi=NULL,
                      unknown='Unknown',
                      foi_colour='grey90'){
  
  fData(obj)[[fcol]] <- update_loc_names(fData(obj)[[fcol]])
  unknown <- update_loc_names(unknown)
  
  n_markers <- length(setdiff(c(getMarkerClasses(obj, fcol)), unknown))

  .data <- obj %>% fData() %>% mutate(markers=!!sym(fcol)) %>% arrange(markers!=unknown)
  
  if(!missing(foi)){
    if(any(!foi %in% rownames(.data))){
      stop('some proteins in foi are not present in obj')
    }
  }
  
  .data$is_marker <- .data$markers != unknown

  p <- .data %>%
    ggplot(aes(`Dimension 1`, `Dimension 2`,
               colour=markers,
               alpha=is_marker,
               size=is_marker)) +
    scale_colour_manual(values=c(getStockcol()[1:n_markers], foi_colour), name='') +
    scale_alpha_manual(values=c(0.5, 1), guide=FALSE) +
    scale_size_manual(values=c(0.5, 1), guide=FALSE) +
    geom_point() +
    theme_camprot(border=FALSE, base_size=15)
  
  if(!missing(foi)){
    p <- p + geom_point(data=.data[foi,], shape=8, colour='black', alpha=1, size=5)
  }
  
  return(p)
}


plot_fois <- function(foi,
                      foi_name='FOI',
                      moi='Cytosol',
                      plot_tsne=FALSE,
                      obj=combined_protein_res_inc_bandle,
                      feature_col='bandle_allocation_markers',
                      unknown_desc='Unknown',
                      foi_colour='grey10'){
  
  if(length(foi)>1){
    plot_all_proteins <- TRUE
  } else { plot_all_proteins<-FALSE }
  
  dmso <- obj[[1]] 
  tg <- obj[[2]] 
  
  fData(dmso)[[feature_col]] <- update_loc_names(fData(dmso)[[feature_col]])
  fData(tg)[[feature_col]] <- update_loc_names(fData(dmso)[[feature_col]])
  fData(dmso)$markers <- update_loc_names(fData(dmso)$markers)
  fData(tg)$markers <- update_loc_names(fData(dmso)$markers)
  
  plot2D(dmso, fcol=feature_col, main='DMSO', unknown=unknown_desc)
  addLegend(dmso, fcol=feature_col, where='bottomright', cex=0.5)
  highlightOnPlot(dmso, foi=foi, pch=8, cex=3)
  
  plot2D(tg, fcol=feature_col, main='Tg', unknown=unknown_desc)
  addLegend(tg, fcol=feature_col, where='bottomright', cex=0.5)
  highlightOnPlot(tg, foi=foi, pch=8, cex=3)
  
  if(plot_tsne){
    print(plot_tsne(dmso, fcol='markers', foi, unknown='unknown'))
    print(plot_tsne(tg, fcol='markers', foi, unknown='unknown'))
    print(plot_tsne(dmso, fcol=feature_col, foi, unknown=unknown_desc))
    print(plot_tsne(tg, fcol=feature_col, foi, unknown=unknown_desc))
  }
  
  
  markers <- getMarkerClasses(dmso)
  moi_colours <- getStockcol()[1:length(markers)]
  linear_colours <- moi_colours[markers %in% moi]
  
  fData(dmso)$markers[rownames(dmso) %in% foi] <- foi_name
  fData(tg)$markers[rownames(tg) %in% foi] <- foi_name
  
  dmso_moi <- dmso[fData(dmso)$markers %in% c(moi, foi_name),]
  tg_moi <- tg[fData(tg)$markers %in% c(moi, foi_name),]
  
  fData(dmso_moi)$markers <- factor(fData(dmso_moi)$markers, levels=c(sort(moi), foi_name))   
  fData(tg_moi)$markers <- factor(fData(tg_moi)$markers, levels=c(sort(moi), foi_name))
  
  if(plot_all_proteins){
    p <- plot_marker_profiles(dmso_moi, group_by='replicate',
                              alpha=c(rep(0.1, length(moi)), 10/length(foi))) +
      facet_wrap(~replicate, ncol=3, scales='free_x') +
      scale_colour_manual(values=c(linear_colours, foi_colour), name='') +
      scale_x_discrete(labels=1:8) +
      theme_camprot(base_size=15, border=FALSE) +
      theme(strip.background=element_blank()) +
      ggtitle('DMSO')
    print(p)
    
    p <- plot_marker_profiles(tg_moi, group_by='replicate', 
                              alpha=c(rep(0.1, length(moi)), 10/length(foi))) +
      facet_wrap(~replicate, ncol=3, scales='free_x') +
      scale_colour_manual(values=c(linear_colours, foi_colour), name='') +
      scale_x_discrete(labels=1:8) +
      theme_camprot(base_size=15, border=FALSE) +
      theme(strip.background=element_blank()) +
      ggtitle('Tg')
    print(p)
  } else{
    p <- plot_marker_profiles(dmso_moi,
                              group_by='replicate', plot_all=F) +
      facet_wrap(~replicate, ncol=3, scales='free_x') +
      scale_colour_manual(values=c(linear_colours, foi_colour), name='') +
      scale_x_discrete(labels=1:8) +
      theme_camprot(base_size=15, border=FALSE) +
      theme(strip.background=element_blank()) +
      ggtitle('DMSO')
    
    print(p)
    
    p <- plot_marker_profiles(tg_moi,
                              group_by='replicate', plot_all=F) +
      facet_wrap(~replicate, ncol=3, scales='free_x') +
      scale_colour_manual(values=c(linear_colours, foi_colour), name='') +
      scale_x_discrete(labels=1:8) +
      theme_camprot(base_size=15, border=FALSE) +
      theme(strip.background=element_blank()) +
      ggtitle('Tg')
    print(p)
    
  }
  
}


compare_profiles <- function(foi, obj=combined_protein_res_inc_bandle){
  p <- obj %>% lapply(function(x) tidy(x[foi,], addPheno=TRUE)) %>%
    bind_rows() %>%
    merge(fData(obj[[1]])[,174:177], by.x='protein', by.y='row.names') %>%
    mutate(name=gsub(' .*', '', GENES)) %>%
    ggplot(aes(fraction, value, group=interaction(condition, protein, replicate), colour=condition)) +
    geom_line(size=0.5) +
    theme_camprot(base_size=15, base_family='sans', border=FALSE) +
    facet_wrap(~name) +
    scale_x_continuous(breaks=1:8, name='Fraction') +
    ylab('Abundance (sum norm.)') +
    scale_colour_manual(values=get_cat_palette(2), name='') +
    theme(strip.background=element_blank())
  
  return(p)
}

