//
//  EBIniciativasTableViewController.m
//  MiCongreso
//

//  Copyright (c) 2013 Eduardo Blancas https://github.com/edublancas
//
//  MIT LICENSE
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.

#import "EBIniciativasTableViewController.h"

@interface EBIniciativasTableViewController ()

@end


#define kFontSize 15.0f
#define kTopMargin 5.0f
#define kBottomMargin 5.0f
#define kMaxLines 3

@implementation EBIniciativasTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    font = [UIFont boldSystemFontOfSize:kFontSize];
    
    self.navigationItem.title = @"Iniciativas";
    
    iniciativas = [[NSMutableArray alloc]init];
    
    reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    [reach startNotifier];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *button =[[UIBarButtonItem alloc]
                              initWithImage:[UIImage imageNamed:@"42-info.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(aboutView)];
	
    [self.navigationItem setRightBarButtonItem:button animated:NO];
    
}

-(void)reachabilityChanged:(SCNetworkReachabilityFlags)flag{
    if (![reach isReachable]) {
        [SVStatusHUD showWithImage:[UIImage imageNamed:@"no.png"]
                            status:@"No hay conexión" duration:3.0];
    }else{
        isLoading = YES;
        [self cargarIniciativas];
        
    }

}



-(void)aboutView{
    AboutViewController *controller = [[AboutViewController alloc]init];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [iniciativas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.font = font;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = kMaxLines;
    cell.textLabel.text = [[iniciativas objectAtIndex:indexPath.row]descripcion];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize maxSize = CGSizeMake(310.0f , 100.0f);
	CGSize size = [[[iniciativas objectAtIndex:indexPath.row]descripcion]sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
    return size.height+kTopMargin+kBottomMargin;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%@", [[iniciativas objectAtIndex:indexPath.row]recursosAdicionales]);
    [self performSegueWithIdentifier:@"details" sender:[iniciativas objectAtIndex:indexPath.row]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"details"]) {
        EBIniciativaDetallesTableViewController *destination = segue.destinationViewController;
        destination.iniciativa = sender;
       // NSLog(@"sender %@", sender);
    }
}

-(void)cargarIniciativas{
    [[EBProgressIndicator sharedProgressIndicator]addProcessToQueue];
    numeroDePaginasMostradas++;
     NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://curul501.org/iniciativas/page/%d", numeroDePaginasMostradas]];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:URL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if (data){
            TFHpple *parser = [TFHpple hppleWithHTMLData:data];
            NSString *queryString = @"//article[@class='iniciativa']";
            NSArray *nodos = [parser searchWithXPathQuery:queryString];
            if ([nodos count]) {
                for (TFHppleElement *elemento in nodos) {
                    EBIniciativa *iniciativa = [[EBIniciativa alloc]initWithElement:elemento];
                    [iniciativas addObject:iniciativa];
                }
                
                [self.tableView reloadData];
            }
            isLoading = NO;
            [[EBProgressIndicator sharedProgressIndicator]removeProcessFromQueue];
            
        }else if (error)
            NSLog(@"%@",error);
            isLoading = NO;
            [[EBProgressIndicator sharedProgressIndicator]removeProcessFromQueue];
    }];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentYoffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
    
    if(distanceFromBottom <= height)
    {
        if (!isLoading) {
            [self cargarIniciativas];
            NSLog(@"Cargas más...");
            isLoading = YES;
        }
    }
}

@end
