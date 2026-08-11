Here is an email I just got. Help me deal with it.

---

**Subject:** Re: Re: FWD: staging thing + Q3 planning (and the dashboard)

Hey — sorry for the wall of text, been meaning to write this since Tuesday.

So the staging deploy went out Thursday night and mostly fine, though Priya
noticed the p95 on /api/search crept up to about 1.9s, which is roughly double
what we saw before the reindex, and I am not sure if that is the new analyzer or
just cold caches — probably worth someone looking at before we promote to prod.
Speaking of which, are we still targeting the 22nd for that? Marketing has been
asking because the campaign emails are already scheduled and I told them the
22nd, but I honestly cannot remember if we agreed that or if I made it up.

Also the auth migration. I know we said we would wait until after the reindex,
but legal came back and apparently the old session tokens do not meet the
retention policy, so we may need to rotate everything before end of month. That
probably means the mobile team needs a heads up, since their refresh logic
assumes a 30 day window. Can you ping Sam about that, or should I?

Unrelated but while I remember — the dashboard has been showing stale numbers
since roughly the 3rd. Not urgent.

Oh, and I never answered your question about whether we should keep the feature
flag. I think yes for now, at least through the next release, but happy to be
talked out of it.

Finally, the Q3 planning doc needs everyone's sections by Friday. Mine is done.
I think you still owe the infra section, and Priya owes the data one, though she
may have done it already.

Thanks — and again, sorry this got so long.
