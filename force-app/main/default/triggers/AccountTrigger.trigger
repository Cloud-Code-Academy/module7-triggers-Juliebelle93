trigger AccountTrigger on Account (before insert) {
    for (Account acc : Trigger.new) {
        if (acc.Type == null) {
            acc.Type = 'Prospect';
        }
    }
}
