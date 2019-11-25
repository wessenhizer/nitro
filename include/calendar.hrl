-ifndef(CAL_HRL).
-define(CAL_HRL, true).

-include_lib("nitro/include/nitro.hrl").

-record(calendar, {?ELEMENT_BASE(element_calendar),
  autocomplete=true, autofocus=false, disabled=false, form=[], list=[], maxDate={2019,2,2},
    minDate, format="YYYY-MM-DD", pattern=[], name=[], step=[], readonly=[], required=[],
    value={2020,2,2}, placeholder=[], onSelect=[], disableDayFn=[], position=[],
    reposition=[], yearRange=100}).

-endif.