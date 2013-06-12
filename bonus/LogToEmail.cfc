<cfcomponent implements="taffy.bonus.ILogAdapter">

	<cffunction name="init">
		<cfargument name="config" />
		<cfargument name="tracker" hint="unused" default="" />

		<!--- copy settings into adapter instance data --->
		<cfset structAppend( variables, arguments.config, true ) />
		
		<cfreturn this />
	</cffunction>

	<cffunction name="saveLog">
		<cfargument name="exception" />
		<!---
			TODO: This adapter does not currently support authentication-required email, supplying a specific server, etc.
			That would be a great and relatively easy thing for you to contribute back! :)
		--->
		<cfset var pid = structKeyExists(cookie,"pid") ? cookie.pid : 0 />
		<cfset var detail = structKeyExists(exception,"cause") && structKeyExists(exception.cause,"detail") ? exception.cause.detail : "" />
		<cfset var the_host = CreateObject("java", "java.net.InetAddress").getlocalhost().gethostname() />
		<cfmail
			from="#variables.emailFrom#"
			to="#variables.emailTo#"
			subject="#the_host#: #variables.emailSubj#-#pid#"
			type="#variables.emailType#">
				<cfif variables.emailType eq "text">
Exception Report

Exception Timestamp: <cfoutput>#dateformat(now(), 'yyyy-mm-dd')# #timeformat(now(), 'HH:MM:SS tt')#</cfoutput>

<cfdump var="#arguments.exception#" format="text" />
				<cfelse>
					<cfdump var="#detail#" />
					<cfdump var="#cgi.path_info#" />
					<cfdump var="#arguments.exception#" />
					<cfdump var="#url#" />
					<cfdump var="#form#" />
					<cfdump var="#cookie#" />
				</cfif>
		</cfmail>
	</cffunction>

</cfcomponent>