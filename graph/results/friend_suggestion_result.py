class FriendSuggestionResult:

    def __init__(self, suggested_user_id, mutual_friends, score):
        self.suggested_user_id = suggested_user_id
        self.mutual_friends = mutual_friends
        self.score = score
            
    def get_suggested_user_id(self):
        return self.suggested_user_id

    def get_mutual_friends(self):
        return self.mutual_friends

    def get_mutual_friends_count(self):
        return len(self.mutual_friends)

    def get_score(self):
        return self.score