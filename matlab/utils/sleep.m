function sleep(ms)
    if ms < 0
        ms = 0;
    end
    java.lang.Thread.sleep(ms);
end
