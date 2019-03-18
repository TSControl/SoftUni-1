namespace FestivalManager.Entities
{
	using System.Collections.Generic;
	using Contracts;

	public class Stage : IStage
	{
		// да си вкарват през полетата бе
		public readonly List<ISet> Sets;
		public readonly List<ISong> Songs;
		public readonly List<IPerformer> Performers;

		IReadOnlyCollection<ISet> IStage.Sets => throw new System.NotImplementedException();

		IReadOnlyCollection<ISong> IStage.Songs => throw new System.NotImplementedException();

		IReadOnlyCollection<IPerformer> IStage.Performers => throw new System.NotImplementedException();

		public void AddPerformer(IPerformer performer)
		{
			throw new System.NotImplementedException();
		}

		public void AddSet(ISet performer)
		{
			throw new System.NotImplementedException();
		}

		public void AddSong(ISong song)
		{
			throw new System.NotImplementedException();
		}

		public IPerformer GetPerformer(string name)
		{
			throw new System.NotImplementedException();
		}

		public ISet GetSet(string name)
		{
			throw new System.NotImplementedException();
		}

		public ISong GetSong(string name)
		{
			throw new System.NotImplementedException();
		}

		public bool HasPerformer(string name)
		{
			throw new System.NotImplementedException();
		}

		public bool HasSet(string name)
		{
			throw new System.NotImplementedException();
		}

		public bool HasSong(string name)
		{
			throw new System.NotImplementedException();
		}
	}
}
