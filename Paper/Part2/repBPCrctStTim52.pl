# 修正第52号事件的起始时间错误
use HTTP::Date;
my $newStTime = HTTP::Date::str2time("2010-12-31 13:59:40", '+0800');
my $edTime = HTTP::Date::str2time("2011-01-02 17:30:45", '+0800');
my $newLifetime = ($edTime - $newStTime) / 3600;
print "$newLifetime\n";