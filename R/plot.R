#' Plot usage of a resource over time
#'
#' Plot the usage of a resource over the simulation time frame.
#'
#' @param envs a single simmer environment or a list of environments representing several replications.
#' @param resource_name the name of the resource (character value).
#' @param items the components of the resource to be plotted.
#' @param steps adds the changes in the resource usage.
#'
#' @return Returns a ggplot2 object.
#' @seealso \code{\link{plot_resource_utilization}},
#' \code{\link{plot_evolution_arrival_times}}, \code{\link{plot_attributes}}.
#' @export
plot_resource_usage <- function(envs, resource_name, items=c("system", "queue", "server"), steps = FALSE) {
  checkInstall(c("dplyr", "tidyr", "ggplot2", "scales"))
  # Hack to avoid spurious notes
  resource <- item <- value <- server <- queue <- system <- replication <- time <- NULL

  items <- match.arg(items, several.ok = TRUE)

  limits <- envs %>% get_mon_resources(data = "limits") %>%
    dplyr::filter(resource == resource_name) %>%
    tidyr::gather(item, value, server, queue, system) %>%
    dplyr::mutate(item = factor(item)) %>%
    dplyr::filter(item %in% items)

  monitor_data <- envs %>% get_mon_resources(data = "counts") %>%
    dplyr::filter(resource == resource_name) %>%
    tidyr::gather(item, value, server, queue, system) %>%
    dplyr::mutate(item = factor(item)) %>%
    dplyr::filter(item %in% items) %>%
    dplyr::group_by(resource, replication, item) %>%
    dplyr::mutate(mean = c(0, cumsum(head(value, -1) * diff(time))) / time) %>%
    dplyr::ungroup()

  if (is.list(envs)) env <- envs[[1]]
  else env <- envs

  plot_obj <-
    ggplot2::ggplot(monitor_data) +
    ggplot2::aes(x = time, color = item) +
    ggplot2::geom_line(ggplot2::aes(y = mean, group = interaction(replication, item))) +
    ggplot2::geom_step(ggplot2::aes(y = value, group = interaction(replication, item)), limits, lty = 2) +
    ggplot2::ggtitle(paste("Resource usage:", resource_name)) +
    ggplot2::ylab("in use") +
    ggplot2::xlab("time") +
    ggplot2::expand_limits(y = 0)

  if (steps == T) {
    plot_obj <- plot_obj +
      ggplot2::geom_step(ggplot2::aes(y = value, group = interaction(replication, item)), alpha = .4)
  }

  plot_obj
}

#' Plot utilization of resources
#'
#' Plot the utilization of specified resources in the simulation.
#'
#' @inheritParams plot_resource_usage
#' @param resources a character vector with at least one resource specified - e.g. "c('res1','res2')".
#'
#' @return Returns a ggplot2 object.
#' @seealso \code{\link{plot_resource_usage}},
#' \code{\link{plot_evolution_arrival_times}}, \code{\link{plot_attributes}}.
#' @export
plot_resource_utilization <- function(envs, resources) {
  checkInstall(c("dplyr", "tidyr", "ggplot2", "scales"))
  # Hack to avoid spurious notes
  resource <- item <- value <- server <- queue <- system <- replication <- capacity <- runtime <-
    in_use <- utilization <- Q25 <- Q50 <- Q75 <- time <- NULL

  if (is.list(envs)) env <- envs[[1]]
  else env <- envs

  monitor_data <- envs %>% get_mon_resources(data = "counts") %>%
    dplyr::filter(resource %in% resources) %>%
    tidyr::gather(item, value, server, queue, system) %>%
    dplyr::mutate(item = factor(item)) %>%
    dplyr::filter(item == "server") %>%
    dplyr::group_by(resource) %>%
    dplyr::mutate(capacity = get_capacity(env, resource[[1]])) %>%
    dplyr::group_by(replication) %>%
    dplyr::mutate(runtime = max(time)) %>%
    dplyr::group_by(resource, replication, capacity, runtime) %>%
    dplyr::mutate(in_use = (time - dplyr::lag(time)) * dplyr::lag(value)) %>%
    dplyr::group_by(resource, replication, capacity, runtime) %>%
    dplyr::summarise(in_use = sum(in_use, na.rm = T)) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(utilization = in_use / capacity / runtime) %>%
    dplyr::group_by(resource, capacity) %>%
    dplyr::summarise(Q25 = stats::quantile(utilization, .25),
                     Q50 = stats::quantile(utilization, .5),
                     Q75 = stats::quantile(utilization, .75))

  ggplot2::ggplot(monitor_data) +
    ggplot2::aes(x = resource, y = Q50, ymin = Q25, ymax = Q75) +
    ggplot2::geom_bar(stat = "identity") +
    ggplot2::geom_errorbar(width = .25, color = "black") +
    ggplot2::ggtitle("Resource utilization") +
    ggplot2::scale_y_continuous(labels = scales::percent, limits = c(0, 1), breaks = seq(0, 2, .2)) +
    ggplot2::ylab("utilization")
}

#' Plot evolution of arrival times
#'
#' Plot the evolution of arrival related times (flow, activity and waiting time).
#'
#' @inheritParams plot_resource_usage
#' @param type one of \code{c("activity_time", "waiting_time", "flow_time")}.
#'
#' @return Returns a ggplot2 object.
#' @seealso \code{\link{plot_resource_usage}}, \code{\link{plot_resource_utilization}},
#' \code{\link{plot_attributes}}.
#' @export
plot_evolution_arrival_times <- function(envs, type=c("activity_time", "waiting_time", "flow_time")){
  checkInstall(c("dplyr", "tidyr", "ggplot2", "scales"))
  # Hack to avoid spurious notes
  end_time <- start_time <- flow_time <- activity_time <-
    replication <- waiting_time <- NULL

  type <- match.arg(type)

  monitor_data <- envs %>% get_mon_arrivals() %>%
    dplyr::mutate(flow_time = end_time - start_time,
                  waiting_time = flow_time - activity_time)

  if (type == "flow_time") {
    ggplot2::ggplot(monitor_data) +
      ggplot2::aes(x = end_time, y = flow_time) +
      ggplot2::geom_line(alpha = .4, ggplot2::aes(group = replication)) +
      ggplot2::stat_smooth() +
      ggplot2::xlab("simulation time") +
      ggplot2::ylab("flow time") +
      ggplot2::ggtitle("Flow time evolution") +
      ggplot2::expand_limits(y = 0)
  } else if (type == "waiting_time") {
    ggplot2::ggplot(monitor_data) +
      ggplot2::aes(x = end_time, y = waiting_time) +
      ggplot2::geom_line(alpha = .4, ggplot2::aes(group = replication)) +
      ggplot2::stat_smooth() +
      ggplot2::xlab("simulation time") +
      ggplot2::ylab("waiting time") +
      ggplot2::ggtitle("Waiting time evolution") +
      ggplot2::expand_limits(y = 0)
  } else if (type == "activity_time") {
    ggplot2::ggplot(monitor_data) +
      ggplot2::aes(x = end_time, y = activity_time) +
      ggplot2::geom_line(alpha = .4, ggplot2::aes(group = replication)) +
      ggplot2::stat_smooth() +
      ggplot2::xlab("simulation time") +
      ggplot2::ylab("activity time") +
      ggplot2::ggtitle("Activity time evolution") +
      ggplot2::expand_limits(y = 0)
  }
}

#' Plot evolution of attribute data
#'
#' Plot the evolution of user-supplied attribute data.
#'
#' @inheritParams plot_resource_usage
#' @param keys the keys of attributes you want to plot (if left empty, all attributes are shown).
#'
#' @return Returns a ggplot2 object.
#' @seealso \code{\link{plot_resource_usage}}, \code{\link{plot_resource_utilization}},
#' \code{\link{plot_evolution_arrival_times}}.
#' @export
plot_attributes <- function(envs, keys=c()) {
  checkInstall(c("dplyr", "tidyr", "ggplot2", "scales"))
  # Hack to avoid spurious notes
  time <- key <- value <- replication <- NULL

  monitor_data <- envs %>% get_mon_attributes()

  if (length(keys) > 0) monitor_data <- monitor_data %>% dplyr::filter(key %in% keys)

  plot_obj <-
    ggplot2::ggplot(monitor_data) +
    ggplot2::aes(x = time, y = value) +
    ggplot2::geom_step(alpha = .4, ggplot2::aes(group = replication)) +
    ggplot2::stat_smooth() +
    ggplot2::xlab("simulation time") +
    ggplot2::ylab("value") +
    ggplot2::expand_limits(y = 0)

  if (length(unique(monitor_data$key)) > 1) {
    plot_obj <- plot_obj +
      ggplot2::ggtitle("Attribute evolution") +
      ggplot2::facet_wrap(~key, scales = "free_y")
  } else {
    plot_obj <- plot_obj +
      ggplot2::ggtitle(paste0("Attribute evolution: ", monitor_data$key[[1]]))
  }

  plot_obj

}
