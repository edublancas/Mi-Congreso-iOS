//
//  EBIniciativasTableViewController.m
//  MiCongreso
//
//  Created by Edu on 17/03/13.
//  Copyright (c) 2013 Eduardo Blancas. All rights reserved.
//

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
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    font = [UIFont boldSystemFontOfSize:kFontSize];
    
    self.navigationItem.title = @"Iniciativas en Curul501";
    
    iniciativas = [[NSMutableArray alloc]init];
    [SVStatusHUD showWithImage:[UIImage imageNamed:@"update.png"] status:@"Cargando..." duration:3];
    [self cargarIniciativas];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
            }else{
                [SVStatusHUD showWithImage:[UIImage imageNamed:@"no.png"] status:@"No hay más datos" duration:3];
            }
            isLoading = NO;
        }
        else if (error)
            NSLog(@"%@",error);
            isLoading = NO;
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
            [SVStatusHUD showWithImage:[UIImage imageNamed:@"update.png"] status:@"Cargando..." duration:3];
            isLoading = YES;
        }
    }
}

@end
