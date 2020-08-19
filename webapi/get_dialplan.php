<?php
    // User $_GET['Caller-Caller-ID-Number'] is calling a number

    if($_GET['Caller-Caller-ID-Number'] === '1000' || $_GET['Caller-Caller-ID-Number'] === '1001') {
        $conferenceName = 'internal';
    } else {
        $conferenceName = 'external';
    }
?><document type="freeswitch/xml">
    <section name="dialplan" description="RE Dial Plan For FreeSwitch">
        <context name="public">
            <extension name="Media Server">
                <condition field="destination_number" expression="^(999)$">
                    <action application="answer"/>
                    <action application="conference" data="<?php echo $conferenceName; ?>@myprofile"/>
                </condition>
            </extension>
        </context>
    </section>
</document>
