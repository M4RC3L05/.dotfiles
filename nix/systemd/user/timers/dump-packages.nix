{
  Unit = {
    Description = "Timer for dump-packages service";
  };
  Timer = {
    OnCalendar = "*:0/1";
  };
  Install = {
    WantedBy = [ "timers.target" ];
  };
}
