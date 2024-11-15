

library(ggplot2)
library(gtable)
library(grid)

my_triangle_colourbar <- function(...) {
  guide <- guide_colourbar(...)
  class(guide) <- c("my_triangle_colourbar", class(guide))
  guide
}

guide_gengrob.my_triangle_colourbar <- function(...) {
  # First draw normal colourbar
  guide <- NextMethod()
  # Extract bar / colours
  is_bar <- grep("^bar$", guide$layout$name)
  bar <- guide$grobs[[is_bar]]
  extremes <- c(bar$raster[1], bar$raster[length(bar$raster)])
  # Extract size
  width  <- guide$widths[guide$layout$l[is_bar]]
  height <- guide$heights[guide$layout$t[is_bar]]
  short  <- min(convertUnit(width, "cm",  valueOnly = TRUE),
                convertUnit(height, "cm", valueOnly = TRUE))
  # Make space for triangles
  guide <- gtable_add_rows(guide, unit(short, "cm"),
                           guide$layout$t[is_bar] - 1)
  guide <- gtable_add_rows(guide, unit(short, "cm"),
                           guide$layout$t[is_bar])
  
  # Draw triangles
  top <- polygonGrob(
    x = unit(c(0, 0.5, 1), "npc"),
    y = unit(c(0, 1, 0), "npc"),
    gp = gpar(fill = extremes[1], col = NA)
  )
  bottom <- polygonGrob(
    x = unit(c(0, 0.5, 1), "npc"),
    y = unit(c(1, 0, 1), "npc"),
    gp = gpar(fill = extremes[2], col = NA)
  )
  # Add triangles to guide
  guide <- gtable_add_grob(
    guide, top, 
    t = guide$layout$t[is_bar] - 1,
    l = guide$layout$l[is_bar]
  )
  guide <- gtable_add_grob(
    guide, bottom,
    t = guide$layout$t[is_bar] + 1,
    l = guide$layout$l[is_bar]
  )
  
  return(guide)
}


#palettes

# color palettes for each source
GAUGE_BASED_PALETTE <- c(
  "E-OBS v29e" = "#88CCEE",
  "EM-EARTH" = "#CC6677",
  "GPCC v2020" = "#117733"
)

REANALYSIS_BASED_PALETTE <- c(
  "ERA5-Land" = "#DDCC77",
  "MERRA2-Land" = "#999933",
  "MSWEP 2.8" = "#882255",
  "MSWX-Past" = "#888888"
)

SATELLITE_BASED_PALETTE <- c(
  "GPCP v3.2" = "#332288",
  "GPM-IMERG v6" = "#AA4499",
  "GSMaP v8" = "#44AA99"
)


#slope palettes

slope_palettes <- colorRampPalette(brewer.pal(n = 10, name = "BrBG"))(100)

#palette for upsets 
rating_scale = scale_fill_manual(values=c(
  "E-OBS v29e" = "#88CCEE",
  "EM-EARTH" = "#CC6677",
  "GPCC v2020" = "#117733","GPCP v3.2" = "#332288",
  "GPM-IMERG v6" = "#AA4499",
  "GSMaP v8" = "#44AA99","ERA5-Land" = "#DDCC77",
  "MERRA2-Land" = "#999933",
  "MSWEP v2.8" = "#882255",
  "MSWX-Past" = "#888888"))


#upset plot function

plot_upset <- function(data, combination, n_intersection = 8, min_degree = 3, max_degree = 100) {
  
  upset(
    data,
    intersect = combination,
    n_intersection = n_intersection,
    min_degree = min_degree,
    max_degree = max_degree,
    sort_sets = "descending",
    name = "",
    matrix = (
      intersection_matrix(
        geom = geom_point(
          shape = 'square',
          size = 3.5
        ),
        segment = geom_segment(
          linetype = 'dotted'
        ),
        outline_color = list(
          active = 'black',
          inactive = 'grey70'
        )
      )
    ),
    base_annotations = list(
      'MPAA Rating' = (
        ggplot(mapping = aes(x = intersection, fill = dataset)) +
          geom_bar(stat = 'count', position = 'fill', na.rm = TRUE, width = 0.8) +
          geom_text(
            aes(label = !!aes_percentage(relative_to = 'group', digits = 1),
                group = dataset
            ),
            stat = 'count',
            position = position_fill(vjust = .5)
          )
        + rating_scale
        + scale_color_manual(values = c('show' = 'black', 'hide' = 'transparent'),
                             guide = 'none') +
          ylab('') +
          xlab('') +
          theme(
            axis.text.y = element_blank(),
            plot.background = element_rect(fill = 'white'),
            axis.ticks.y = element_blank(),
            axis.title.x = element_blank(),
            legend.title = element_blank(),
            legend.key.size = unit(1, "line")
          )
      )
    ),
    width_ratio = 0.2,
    set_sizes = (
      upset_set_size(
        geom = geom_bar(
          aes(x = group),
          width = 0.5
        ),
        position = 'right'
      ) +ylab('Gridcells')+
        theme(
        axis.text.x = element_text(angle = 90),
        axis.title = element_text()
      )
    ),
    guides = 'over'
  )
}

# Function to plot quantile slopes

qq_plot <- function(data, median_data, palette) {
  ggplot(data,
         aes(
           x = quantile,
           y = mean_slope,
           color = dataset,
           group = dataset
         )) +
    geom_point(shape = 19,
               size = 2,
               alpha = 0.7) +
    geom_smooth(method = "loess",
                se = FALSE,
                aes(color = dataset),
                size = 1) +
    geom_smooth(data = median_data, aes(x = quantile, y = median), 
                size = 2, color = "black", method = "loess") +
    geom_abline(
      slope = 0,
      intercept = 0,
      linetype = "dashed",
      color = "black"
    ) +  # Add a line with slope 0
    labs(
      title = "",
      x = "Quantiles",
      y = "Slope"
    ) +
    scale_x_discrete(
      breaks = c("5%", "30%", "60%", "90%"),
      labels = c("5%", "30%", "60%", "90%")
    ) +
    scale_color_manual(values = palette) +
    scale_y_continuous(breaks = scales::pretty_breaks(n = 7)) +
    theme_minimal() +
    theme_bw() +
    theme(
      legend.position = "none",
      panel.grid = element_blank(),
      legend.title = element_blank(),
      axis.title = element_text(size = 14, family = "sans", colour = "black"),
      axis.text = element_text(
        size = 12,
        family = "sans",
        color = "black"
      )
    )
}


