// This file was generated by Rcpp::compileAttributes
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

// Simulator__new
SEXP Simulator__new(SEXP name_, SEXP verbose_);
RcppExport SEXP simmer_Simulator__new(SEXP name_SEXP, SEXP verbose_SEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< SEXP >::type name_(name_SEXP);
    Rcpp::traits::input_parameter< SEXP >::type verbose_(verbose_SEXP);
    __result = Rcpp::wrap(Simulator__new(name_, verbose_));
    return __result;
END_RCPP
}
// reset_
void reset_(SEXP sim_);
RcppExport SEXP simmer_reset_(SEXP sim_SEXP) {
BEGIN_RCPP
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< SEXP >::type sim_(sim_SEXP);
    reset_(sim_);
    return R_NilValue;
END_RCPP
}
// schedule_
void schedule_(SEXP delay_, SEXP arrival_);
RcppExport SEXP simmer_schedule_(SEXP delay_SEXP, SEXP arrival_SEXP) {
BEGIN_RCPP
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< SEXP >::type delay_(delay_SEXP);
    Rcpp::traits::input_parameter< SEXP >::type arrival_(arrival_SEXP);
    schedule_(delay_, arrival_);
    return R_NilValue;
END_RCPP
}
// peek_
double peek_(SEXP sim_);
RcppExport SEXP simmer_peek_(SEXP sim_SEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< SEXP >::type sim_(sim_SEXP);
    __result = Rcpp::wrap(peek_(sim_));
    return __result;
END_RCPP
}
// step_
void step_(SEXP sim_);
RcppExport SEXP simmer_step_(SEXP sim_SEXP) {
BEGIN_RCPP
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< SEXP >::type sim_(sim_SEXP);
    step_(sim_);
    return R_NilValue;
END_RCPP
}
// run_
void run_(SEXP sim_, SEXP until_);
RcppExport SEXP simmer_run_(SEXP sim_SEXP, SEXP until_SEXP) {
BEGIN_RCPP
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< SEXP >::type sim_(sim_SEXP);
    Rcpp::traits::input_parameter< SEXP >::type until_(until_SEXP);
    run_(sim_, until_);
    return R_NilValue;
END_RCPP
}
// add_generator_
void add_generator_(SEXP sim_, SEXP name_prefix_, SEXP first_activity_, SEXP dist_, SEXP mon_);
RcppExport SEXP simmer_add_generator_(SEXP sim_SEXP, SEXP name_prefix_SEXP, SEXP first_activity_SEXP, SEXP dist_SEXP, SEXP mon_SEXP) {
BEGIN_RCPP
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< SEXP >::type sim_(sim_SEXP);
    Rcpp::traits::input_parameter< SEXP >::type name_prefix_(name_prefix_SEXP);
    Rcpp::traits::input_parameter< SEXP >::type first_activity_(first_activity_SEXP);
    Rcpp::traits::input_parameter< SEXP >::type dist_(dist_SEXP);
    Rcpp::traits::input_parameter< SEXP >::type mon_(mon_SEXP);
    add_generator_(sim_, name_prefix_, first_activity_, dist_, mon_);
    return R_NilValue;
END_RCPP
}
// add_resource_
void add_resource_(SEXP sim_, SEXP name_, SEXP capacity_, SEXP queue_size_, SEXP mon_);
RcppExport SEXP simmer_add_resource_(SEXP sim_SEXP, SEXP name_SEXP, SEXP capacity_SEXP, SEXP queue_size_SEXP, SEXP mon_SEXP) {
BEGIN_RCPP
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< SEXP >::type sim_(sim_SEXP);
    Rcpp::traits::input_parameter< SEXP >::type name_(name_SEXP);
    Rcpp::traits::input_parameter< SEXP >::type capacity_(capacity_SEXP);
    Rcpp::traits::input_parameter< SEXP >::type queue_size_(queue_size_SEXP);
    Rcpp::traits::input_parameter< SEXP >::type mon_(mon_SEXP);
    add_resource_(sim_, name_, capacity_, queue_size_, mon_);
    return R_NilValue;
END_RCPP
}
// get_mon_arrivals_
SEXP get_mon_arrivals_(SEXP sim_);
RcppExport SEXP simmer_get_mon_arrivals_(SEXP sim_SEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< SEXP >::type sim_(sim_SEXP);
    __result = Rcpp::wrap(get_mon_arrivals_(sim_));
    return __result;
END_RCPP
}
// get_mon_resource_
SEXP get_mon_resource_(SEXP sim_, SEXP name_);
RcppExport SEXP simmer_get_mon_resource_(SEXP sim_SEXP, SEXP name_SEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< SEXP >::type sim_(sim_SEXP);
    Rcpp::traits::input_parameter< SEXP >::type name_(name_SEXP);
    __result = Rcpp::wrap(get_mon_resource_(sim_, name_));
    return __result;
END_RCPP
}
// get_res_capacity_
int get_res_capacity_(SEXP sim_, SEXP name_);
RcppExport SEXP simmer_get_res_capacity_(SEXP sim_SEXP, SEXP name_SEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< SEXP >::type sim_(sim_SEXP);
    Rcpp::traits::input_parameter< SEXP >::type name_(name_SEXP);
    __result = Rcpp::wrap(get_res_capacity_(sim_, name_));
    return __result;
END_RCPP
}
// get_res_queue_size_
int get_res_queue_size_(SEXP sim_, SEXP name_);
RcppExport SEXP simmer_get_res_queue_size_(SEXP sim_SEXP, SEXP name_SEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< SEXP >::type sim_(sim_SEXP);
    Rcpp::traits::input_parameter< SEXP >::type name_(name_SEXP);
    __result = Rcpp::wrap(get_res_queue_size_(sim_, name_));
    return __result;
END_RCPP
}
// seize_
int seize_(SEXP name_, SEXP arrival_, SEXP amount_);
RcppExport SEXP simmer_seize_(SEXP name_SEXP, SEXP arrival_SEXP, SEXP amount_SEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< SEXP >::type name_(name_SEXP);
    Rcpp::traits::input_parameter< SEXP >::type arrival_(arrival_SEXP);
    Rcpp::traits::input_parameter< SEXP >::type amount_(amount_SEXP);
    __result = Rcpp::wrap(seize_(name_, arrival_, amount_));
    return __result;
END_RCPP
}
// release_
int release_(SEXP name_, SEXP arrival_, SEXP amount_);
RcppExport SEXP simmer_release_(SEXP name_SEXP, SEXP arrival_SEXP, SEXP amount_SEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< SEXP >::type name_(name_SEXP);
    Rcpp::traits::input_parameter< SEXP >::type arrival_(arrival_SEXP);
    Rcpp::traits::input_parameter< SEXP >::type amount_(amount_SEXP);
    __result = Rcpp::wrap(release_(name_, arrival_, amount_));
    return __result;
END_RCPP
}
