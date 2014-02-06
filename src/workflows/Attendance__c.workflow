<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Tick_attended</fullName>
        <field>Attended__c</field>
        <literalValue>1</literalValue>
        <name>Tick attended</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Untick_attended</fullName>
        <field>Attended__c</field>
        <literalValue>0</literalValue>
        <name>Untick attended</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_status_to_attended</fullName>
        <field>Status__c</field>
        <literalValue>Attended</literalValue>
        <name>Update status to attended</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_status_to_booked</fullName>
        <field>Status__c</field>
        <literalValue>Booked</literalValue>
        <name>Update status to booked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update checkbox on status</fullName>
        <actions>
            <name>Tick_attended</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Attendance__c.Status__c</field>
            <operation>equals</operation>
            <value>Attended</value>
        </criteriaItems>
        <description>When the status changes to Attended, tick the attended checkbox</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update checkbox on status unattended</fullName>
        <actions>
            <name>Untick_attended</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Attendance__c.Status__c</field>
            <operation>notEqual</operation>
            <value>Attended</value>
        </criteriaItems>
        <description>When the status changes to not Attended, untick the attended checkbox</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update status on attended</fullName>
        <actions>
            <name>Update_status_to_attended</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Attendance__c.Attended__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>When the attended checkbox is ticked update status to Attended</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update status on not attended</fullName>
        <actions>
            <name>Update_status_to_booked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Attendance__c.Attended__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>When the attended checkbox is unticked update status to Booked (because can&apos;t decide which no show option)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
