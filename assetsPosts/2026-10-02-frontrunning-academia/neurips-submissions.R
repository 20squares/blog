# Rebuild with: Rscript --vanilla assetsPosts/2026-10-02-frontrunning-academia/neurips-submissions.R
# Main-track submission counts, retrieved 2026-10-02.
# 2023: https://media.neurips.cc/Conferences/NeurIPS2023/NeurIPS2023-Fact_Sheet.pdf
# 2024: https://media.neurips.cc/Conferences/NeurIPS2024/NeurIPS2024-Fact_Sheet.pdf
# 2025: https://blog.neurips.cc/2025/09/30/reflections-on-the-2025-review-process-from-the-program-committee-chairs/
# 2026: https://dm.cs.univie.ac.at/news/story/four-papers-accepted-at-neurips-2026
# 2023-2025: organizer sources; 2026: participating university research group.
# The 2025 and 2026 reports specify valid submissions. Other tracks are excluded.

script_arg <- grep("^--file=", commandArgs(), value = TRUE)
output_dir <- dirname(normalizePath(sub("^--file=", "", script_arg[[1]])))
years <- c("2023", "2024", "2025", "2026")
submissions <- c(12343, 15671, 21575, 30709)
growth <- round(100 * (tail(submissions, 1) / submissions[1] - 1))
bar_colors <- c("#a8dcd7", "#68c6be", "#20b2aa", "#137c76")
ticks <- seq(0, 35000, 5000)

png(file.path(output_dir, "neurips-submissions.png"),
    width = 1600, height = 940, res = 180, bg = "transparent")
par(mar = c(3.1, 4.8, 4.5, 1), family = "sans", fg = "#222222",
    col.axis = "#666666", col.lab = "#333333", las = 1, xaxs = "i", yaxs = "i")
bars <- barplot(submissions, names.arg = years, ylim = c(0, 36000),
                width = 0.7, space = c(0.6, 0.7, 0.7, 0.7), axes = FALSE,
                col = bar_colors, border = NA,
                cex.names = 1.15)
abline(h = ticks, col = "#e2e2e2", lwd = 0.8)
# Draw bars over the grid without drawing the category labels twice.
rect(bars - 0.35, 0, bars + 0.35, submissions,
     col = bar_colors, border = NA)
axis(2, at = ticks,
     labels = format(ticks, big.mark = ",", trim = TRUE),
     tick = FALSE, cex.axis = 0.95)
text(bars, submissions + 1000, labels = format(submissions, big.mark = ","),
     font = 2, cex = 1.2, col = "#222222")
mtext("NeurIPS main-track submissions", side = 3, line = 2.2,
      adj = 0, cex = 1.4, font = 2, col = "#222222")
mtext(paste0("2023 to 2026: ", growth, "% more submissions in three years"),
      side = 3, line = 0.65, adj = 0, cex = 0.95, col = "#666666")
invisible(dev.off())
