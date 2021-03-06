context("resource-schedule")

test_that("a schedule name conflicts with a generator name", {
  expect_error(simmer(verbose = TRUE) %>%
    add_generator("asdf", create_trajectory() %>% timeout(0), at(0)) %>%
    add_resource("asdf", schedule(c(1, 2), c(1, 1)))
  )
})

test_that("a schedule cannot be created if the corresponding resource doesn't exist", {
  ptr <- Simulator__new("dummy", FALSE)
  expect_error(add_resource_manager_(ptr, "name", "capacity", c(0, 1), c(0, 1), -1))
})

test_that("capacity & queue size change", {
  inf_sch <- schedule(c(8, 16, 24), c(1, 2, 3), Inf)
  fin_sch <- schedule(c(8, 16, 24), c(1, 2, 3), 24)

  expect_output(print(inf_sch))

  limits <- simmer(verbose = TRUE) %>%
    add_resource("dummy", inf_sch) %>%
    run(17) %>% reset() %>% run(49) %>%
    get_mon_resources("limits")

  expect_equal(limits$time, c(8, 16, 24))
  expect_equal(limits$server, c(1, 2, 3))

  limits <- simmer(verbose = TRUE) %>%
    add_resource("dummy", fin_sch) %>%
    run(17) %>% reset() %>% run(49) %>%
    get_mon_resources("limits")

  expect_equal(limits$time, c(8, 16, 24, 32, 40, 48))
  expect_equal(limits$server, c(1, 2, 3, 1, 2, 3))
})

test_that("queue size changes", {
  inf_sch <- schedule(c(8, 16, 24), c(1, 2, 3), Inf)
  fin_sch <- schedule(c(8, 16, 24), c(1, 2, 3), 24)

  limits <- simmer(verbose = TRUE) %>%
    add_resource("dummy", 1, inf_sch) %>%
    run(17) %>% reset() %>% run(49) %>%
    get_mon_resources("limits")

  expect_equal(limits$time, c(8, 16, 24))
  expect_equal(limits$queue, c(1, 2, 3))

  limits <- simmer(verbose = TRUE) %>%
    add_resource("dummy", 1, fin_sch) %>%
    run(17) %>% reset() %>% run(49) %>%
    get_mon_resources("limits")

  expect_equal(limits$time, c(8, 16, 24, 32, 40, 48))
  expect_equal(limits$queue, c(1, 2, 3, 1, 2, 3))
})

test_that("arrivals 1) are dequeued when resource's capacity increases and
                    2) remain in server when it decreases", {
  t <- create_trajectory() %>%
    seize("dummy", 1) %>%
    timeout(2) %>%
    release("dummy", 1)

  inf_sch <- schedule(c(0, 1, 2), c(1, 3, 1), Inf)

  arrivals <- simmer(verbose = TRUE) %>%
    add_resource("dummy", inf_sch) %>%
    add_generator("asdf", t, at(0, 0, 0)) %>%
    run() %>%
    get_mon_arrivals()

  expect_equal(arrivals$end_time, c(2, 3, 3))
  expect_equal(arrivals$activity_time, c(2, 2, 2))
})

test_that("arrivals 1) are dequeued when resource's capacity increases and
                    2) remain in server when it decreases", {
  t <- create_trajectory() %>%
    seize("dummy", 1) %>%
    timeout(2) %>%
    release("dummy", 1)

  inf_sch <- schedule(c(0, 1, 2), c(1, 3, 1), Inf)

  arrivals <- simmer(verbose = TRUE) %>%
    add_resource("dummy", inf_sch) %>%
    add_generator("asdf", t, at(0, 0, 0)) %>%
    run() %>%
    get_mon_arrivals()

  expect_equal(arrivals$end_time, c(2, 3, 3))
  expect_equal(arrivals$activity_time, c(2, 2, 2))
})

test_that("arrivals are preempted when resource's capacity decreases", {
  t <- create_trajectory() %>%
    seize("dummy", 1) %>%
    timeout(2) %>%
    release("dummy", 1)

  inf_sch <- schedule(c(0, 1, 2), c(1, 3, 1), Inf)

  arrivals <- simmer(verbose = TRUE) %>%
    add_resource("dummy", inf_sch, preemptive = TRUE) %>%
    add_generator("asdf", t, at(0, 0, 0), restart = TRUE) %>%
    run() %>%
    get_mon_arrivals()

  expect_equal(arrivals$end_time, c(2, 3, 5))
  expect_equal(arrivals$activity_time, c(2, 2, 3))
})

test_that("resource's capacity decreases before post-release tasks", {
  t <- create_trajectory() %>%
    seize("t-rex") %>%
    timeout(5) %>%
    release("t-rex")

  arrivals <- simmer(verbose = TRUE) %>%
    add_resource("t-rex", capacity = schedule(timetable = c(5, 10, 15),
                                              period = Inf,
                                              values = c(1, 0, 1))) %>%
    add_generator("piggy", t, at(0, 0, 0)) %>%
    run() %>%
    get_mon_arrivals()

  expect_equal(arrivals$end_time, c(10, 20, 25))
  expect_equal(arrivals$activity_time, c(5, 5, 5))
})

test_that("capacity decrease on a non-released preemptive resource does not crash", {
  t <- create_trajectory() %>%
    seize("dummy", 1)

  sched <- schedule(c(0, 1), c(1, 0), period = Inf)

  env <- simmer(verbose = TRUE) %>%
    add_resource("dummy", sched, preemptive = TRUE) %>%
    add_generator("arrival", t, at(0))

  expect_warning(run(env))
})
